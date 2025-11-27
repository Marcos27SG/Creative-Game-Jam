shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx;

// Main texture
uniform sampler2D albedo_texture : source_color;

// Construction progress parameters
uniform float progress : hint_range(0.0, 1.0) = 0.5;
uniform float construction_zone_height : hint_range(0.05, 0.5) = 0.15;
uniform float fade_edge : hint_range(0.01, 0.2) = 0.05;

// Building dimensions (IMPORTANT: Set these to match your actual mesh bounds!)
uniform float building_bottom : hint_range(-50.0, 50.0) = 0.0;
uniform float building_top : hint_range(-50.0, 50.0) = 10.0;
uniform bool auto_detect_height  = true;

// Construction effects
uniform vec4 sparks_color : source_color = vec4(1.0, 0.7, 0.2, 1.0);
uniform float sparks_intensity : hint_range(0.0, 5.0) = 2.0;
uniform float sparks_speed : hint_range(1.0, 20.0) = 8.0;
uniform float sparks_scale : hint_range(1.0, 50.0) = 15.0;

// Scaffolding/framework effect
uniform vec4 framework_color : source_color = vec4(0.6, 0.6, 0.7, 1.0);
uniform float framework_thickness : hint_range(0.01, 0.1) = 0.03;
uniform float framework_spacing : hint_range(0.1, 1.0) = 0.25;

// Dust and debris
uniform vec4 dust_color : source_color = vec4(0.8, 0.7, 0.6, 0.3);
uniform float dust_density : hint_range(0.0, 2.0) = 0.8;
uniform float dust_animation_speed : hint_range(0.5, 5.0) = 2.0;

// Construction light/glow
uniform vec4 construction_glow : source_color = vec4(1.0, 0.8, 0.4, 1.0);
uniform float glow_intensity : hint_range(0.0, 3.0) = 1.5;

varying vec3 world_position;
varying vec3 world_normal;

// Enhanced noise functions for better construction effects
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 4; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Generate scaffolding/framework pattern
float scaffolding_pattern(vec2 uv, float construction_line) {
    vec2 grid_uv = uv / framework_spacing;
    vec2 grid_id = floor(grid_uv);
    vec2 grid_local = fract(grid_uv);
    
    // Vertical and horizontal lines
    float vertical_lines = smoothstep(framework_thickness, 0.0, abs(grid_local.x - 0.5));
    float horizontal_lines = smoothstep(framework_thickness, 0.0, abs(grid_local.y - 0.5));
    
    // Only show scaffolding near construction line
    float scaffolding_mask = smoothstep(0.3, 0.0, abs(uv.y - construction_line));
    
    return max(vertical_lines, horizontal_lines) * scaffolding_mask;
}

// Generate sparks and welding effects
float sparks_effect(vec2 uv, float construction_line, float time) {
    vec2 spark_uv = uv * sparks_scale + time * vec2(0.3, -0.8);
    
    float sparks = 0.0;
    for(int i = 0; i < 3; i++) {
        vec2 spark_pos = vec2(hash(vec2(float(i) * 12.34, time * 0.1)), 
                             hash(vec2(float(i) * 45.67, time * 0.1))) * 2.0 - 1.0;
        spark_pos.y = construction_line + spark_pos.y * 0.1;
        
        float dist = distance(uv, spark_pos);
        float spark_intensity = 1.0 / (1.0 + dist * 20.0);
        spark_intensity *= sin(time * sparks_speed + float(i) * 2.0) * 0.5 + 0.5;
        sparks += spark_intensity;
    }
    
    // Only show sparks near construction line
    float spark_mask = smoothstep(0.2, 0.0, abs(uv.y - construction_line));
    return sparks * spark_mask;
}

// Generate dust and debris effect
float dust_effect(vec2 uv, float construction_line, float time) {
    vec2 dust_uv = uv * 3.0 + time * vec2(0.1, -0.5) * dust_animation_speed;
    float dust = fbm(dust_uv) * dust_density;
    
    // More dust near construction line
    float dust_falloff = smoothstep(0.4, 0.0, abs(uv.y - construction_line));
    dust *= dust_falloff;
    
    // Animate dust particles
    dust *= sin(time * 2.0 + uv.x * 10.0) * 0.3 + 0.7;
    
    return clamp(dust, 0.0, 1.0);
}

void vertex() {
    world_position = VERTEX;
    world_normal = NORMAL;
}

void fragment() {
    // Get original texture
    vec4 original_color = texture(albedo_texture, UV);
    
    // Calculate normalized height (0 = bottom, 1 = top)
    float normalized_height;
    
    if (auto_detect_height) {
        // Use UV.y directly (assumes your UV is mapped properly from 0 to 1)
        normalized_height = UV.y;
    } else {
        // Use world position with manual bounds
        float height_range = building_top - building_bottom;
        normalized_height = (world_position.y - building_bottom) / height_range;
    }
    
    normalized_height = clamp(normalized_height, 0.0, 1.0);
    
    // Add some organic variation to construction line
    float construction_noise = fbm(UV * 8.0 + TIME * 0.2) * 0.02; // Reduced noise
    float construction_line = progress + construction_noise;
    
    // Determine construction states
    // Parts below construction line are built
    float fully_built = step(normalized_height, construction_line - construction_zone_height);
    
    // Parts in construction zone (between construction_line - zone_height and construction_line)
    float in_construction = smoothstep(construction_line - construction_zone_height, 
                                      construction_line, normalized_height) * 
                           (1.0 - step(construction_line, normalized_height));
    
    // Parts above construction line are not built yet
    float not_built = step(construction_line, normalized_height);
    
    // Generate construction effects
    float scaffolding = scaffolding_pattern(UV, construction_line);
    float sparks = sparks_effect(UV, construction_line, TIME);
    float dust = dust_effect(UV, construction_line, TIME);
    
    // Construction zone coloring
    vec3 construction_base = mix(original_color.rgb, framework_color.rgb, scaffolding * 0.8);
    construction_base = mix(construction_base, sparks_color.rgb, sparks * sparks_intensity);
    construction_base += construction_glow.rgb * glow_intensity * in_construction * 
                        (sin(TIME * 4.0) * 0.3 + 0.7);
    
    // Add dust overlay
    construction_base = mix(construction_base, dust_color.rgb, dust * dust_color.a);
    
    // Final color mixing
    vec3 final_color = original_color.rgb;
    float final_alpha = original_color.a;
    
    if (not_built > 0.5) {
        // Not yet built - invisible
        final_alpha = 0.0;
    } else if (in_construction > 0.1) {
        // Construction zone with effects
        final_color = construction_base;
        final_alpha = mix(0.7, 1.0, in_construction);
    } else {
        // Fully built - normal appearance
        final_color = original_color.rgb;
        final_alpha = original_color.a;
    }
    
    // Only apply edge fade if we're actually showing something
    if (final_alpha > 0.0) {
        float edge_fade = smoothstep(construction_line - fade_edge, construction_line + fade_edge, normalized_height);
        edge_fade = 1.0 - edge_fade; // Invert so lower parts are visible
        final_alpha *= clamp(edge_fade + fully_built, 0.0, 1.0);
    }
    
    ALBEDO = final_color;
    ALPHA = final_alpha;
    
    // Add some emission for construction effects
    float emission_strength = in_construction * (sparks * 0.5 + glow_intensity * 0.2);
    EMISSION = construction_glow.rgb * emission_strength;
}