shader_type sky;

uniform sampler2D texture1 : filter_nearest;
uniform sampler2D texture2 : filter_nearest;
uniform sampler2D texture3 : filter_nearest;

uniform float tiling1 : hint_range(0.1, 20.0) = 4.0;
uniform float tiling2 : hint_range(0.1, 20.0) = 6.0;
uniform float tiling3 : hint_range(0.1, 20.0) = 8.0;

// Current accumulated offsets
uniform vec2 current_offset = vec2(0.0);

// Speed multipliers for parallax
uniform float speed1 : hint_range(0.0, 3.0) = 2.0;  // Fast (close)
uniform float speed2 : hint_range(0.0, 3.0) = 1.0;  // Medium
uniform float speed3 : hint_range(0.0, 3.0) = 0.5;  // Slow (far)

uniform vec3 base_color : source_color = vec3(0.1, 0.1, 0.2);

void sky() {
    vec3 dir = normalize(EYEDIR);
    vec2 base_uv = dir.xz; // this we remove
    base_uv *= 6.0;
	base_uv = base_uv * 0.5 + 0.5;
	
    // Apply parallax by multiplying the same offset with different speeds
    vec2 offset1 = current_offset * speed1;
    vec2 offset2 = current_offset * speed2;
    vec2 offset3 = current_offset * speed3;
    
    vec2 uv1 = (base_uv * tiling1) + offset1;
    vec2 uv2 = (base_uv * tiling2) + offset2;
    vec2 uv3 = (base_uv * tiling3) + offset3;
    
    vec4 layer1 = texture(texture1, fract(uv1));
    vec4 layer2 = texture(texture2, fract(uv2));
    vec4 layer3 = texture(texture3, fract(uv3));
    
    vec4 combined = layer1*0.2 + layer2*0.5 + layer3*0.25;
	//combined = floor(combined * 128.0) / 128.0;
    COLOR = vec4(base_color + combined.rgb, 1.0).rgb;
}