shader_type canvas_item;

uniform sampler2D base_texture;       // Full white
uniform sampler2D letter_texture;     // Letter image

uniform float progress = 0.0;         // Animation time
uniform float chunkiness = 60.0;      // Size of disintegration blocks

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;

    vec4 white = texture(base_texture, uv);
    vec4 letter = texture(letter_texture, uv);
    vec4 inverted = vec4(1.0 - letter.rgb, letter.a);

    // Bigger pixel chunks
    vec2 block_uv = floor(uv * chunkiness) / chunkiness;
    float noise = rand(block_uv);

    // Two masks: white → letter AND letter → inverted
    float appear = smoothstep(0.0, 0.8, progress); // earlier: letter appears
    float invert = smoothstep(0.5, 1.0, progress); // later: invert kicks in

    float from_white = step(appear, noise);   // 1.0 = still white
    float to_invert = step(invert, noise);    // 1.0 = start invert

    // Compose final image
    vec4 result = white; // default: white
   // dissolve letter → inverted
	result = mix(letter, result, from_white);         // dissolve white → letter
	result = mix(inverted, result, to_invert);
    //result = mix(letter, result, from_white);         // dissolve white → letter
    //result = mix(inverted, result, to_invert);        // dissolve letter → inverted

    COLOR = result;
}
