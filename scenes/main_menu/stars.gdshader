shader_type canvas_item;

// Noise texture for star distribution
uniform sampler2D noise_texture : filter_linear_mipmap, repeat_enable;

// Movement parameters
uniform vec2 direction = vec2(1.0, 0.0); // Direction of star movement
uniform float velocity = 0.1; // Speed of star movement
uniform float star_size = 0.02; // Size/thickness of stars
uniform float star_brightness = 1.5; // Brightness multiplier for stars
uniform float star_threshold = 0.7; // Threshold for star visibility (higher = fewer stars)

// Sphere mapping parameters
uniform float sphere_radius = 1.0; // Radius of the virtual sphere
uniform vec2 sphere_rotation = vec2(0.0, 0.0); // Additional rotation offset

void fragment() {
    // Convert UV to centered coordinates (-1 to 1)
    vec2 centered_uv = (UV - 0.5) * 2.0;

    // Calculate spherical coordinates
    float r = length(centered_uv);

    // Create sphere mapping with proper wrapping
    // Using atan for azimuth and asin for elevation
    float azimuth = atan(centered_uv.y, centered_uv.x);
    float elevation = asin(clamp(r / sphere_radius, -1.0, 1.0));

    // Convert to UV coordinates for texture sampling (0 to 1 range)
    vec2 sphere_uv = vec2(
        azimuth / (2.0 * PI) + 0.5,
        elevation / PI + 0.5
    );

    // Apply movement using TIME and direction
    vec2 movement = normalize(direction) * velocity * TIME;
    vec2 animated_uv = sphere_uv + movement + sphere_rotation;

    // Sample the noise texture with wrapping
    float noise = texture(noise_texture, animated_uv).r;

    // Create stars based on threshold
    float star = smoothstep(star_threshold, star_threshold + star_size, noise);

    // Apply brightness
    star *= star_brightness;

    // Fade out at edges to create vignette effect
    float edge_fade = 1.0 - smoothstep(sphere_radius * 0.8, sphere_radius, r);
    star *= edge_fade;

    // Output white stars with calculated alpha
    COLOR = vec4(vec3(1.0), star);
}