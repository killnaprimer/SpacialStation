shader_type sky;

uniform sampler2D sky_texture;
uniform float tiling : hint_range(0.1, 20.0) = 8.0;
uniform float zoom : hint_range(0.1, 5.0) = 1.0;

void sky() {
    vec3 dir = normalize(EYEDIR);
    
    // For top-down view, we primarily care about the XZ plane (ground plane)
    // This creates a "flat" sky that works perfectly for top-down games
    vec2 uv = dir.xz;
    
    // Normalize from [-1,1] to [0,1] range
    uv = uv * 0.5 + 0.5;
    
    // Apply zoom (inverse of tiling for more intuitive control)
    uv = (uv - 0.5) / zoom + 0.5;
    
    // Apply tiling with fract to make it repeat
    uv = fract(uv * tiling);
    
    COLOR = texture(sky_texture, uv).rgb;
}