shader_type canvas_item;

// Shader parameters
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 soot_color:  source_color = vec4(0.1, 0.1, 0.1, 0.8);
uniform float animation_speed : hint_range(0.1, 5.0) = 1.0;
uniform sampler2D noise_texture : source_color;
uniform float noise_scale : hint_range(0.1, 10.0) = 2.0;
uniform float edge_softness : hint_range(0.01, 0.5) = 0.1;
uniform float distortion_strength : hint_range(0.0, 0.2) = 0.05;

varying vec2 world_position;

void vertex() {
    world_position = VERTEX;
}

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    vec2 uv = UV;

    // Calculate distance from center
    float dist = distance(uv, center);

    // Animate the noise over time
    vec2 animated_uv = uv * noise_scale + vec2(TIME * animation_speed * 0.1, TIME * animation_speed * 0.15);

    // Sample noise texture
    float noise = texture(noise_texture, animated_uv).r;

    // Add secondary noise for more complexity
    vec2 secondary_uv = uv * noise_scale * 1.5 + vec2(TIME * animation_speed * -0.08, TIME * animation_speed * 0.12);
    float secondary_noise = texture(noise_texture, secondary_uv).g;

    // Combine noises
    float combined_noise = mix(noise, secondary_noise, 0.3);

    // Create distorted UVs for the expansion effect
    vec2 distorted_center = center + (combined_noise - 0.5) * distortion_strength;
    float distorted_dist = distance(uv, distorted_center);

    // Calculate expansion radius based on progress
    // When progress = 0, radius is very small (closed)
    // When progress = 1, radius covers the whole screen (open)
    float max_radius = sqrt(2.0); // Diagonal distance to cover whole screen
    float expansion_radius = progress * max_radius;

    // Add noise-based variation to the expansion
    float noise_variation = (combined_noise - 0.5) * 0.3;
    float effective_radius = expansion_radius + noise_variation;

    // Calculate alpha based on distance and expansion
    float alpha_mask = 1.0 - smoothstep(effective_radius - edge_softness, effective_radius + edge_softness, distorted_dist);

    // Add some density variation using noise
    float density_variation = 0.7 + combined_noise * 0.6;
    alpha_mask *= density_variation;

    // Create wispy edges effect
    float edge_noise = texture(noise_texture, uv * noise_scale * 3.0 + TIME * animation_speed * 0.2).r;
    float edge_effect = smoothstep(0.3, 0.7, edge_noise);
    alpha_mask *= edge_effect;

    // Apply the soot color with calculated alpha
    vec4 final_color = soot_color;
    final_color.a *= alpha_mask * soot_color.a;

    // Ensure we don't exceed the original alpha
    final_color.a = clamp(final_color.a, 0.0, 1.0);

    COLOR = final_color;
}