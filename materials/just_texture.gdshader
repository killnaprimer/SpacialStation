shader_type spatial;
render_mode blend_mix,
	cull_disabled,
	depth_prepass_alpha,
	specular_disabled;

uniform sampler2D albedo : source_color, filter_nearest;
uniform sampler2D normal : source_color, filter_nearest;
uniform float alpha_scissor : hint_range(0, 1) = 0.5;

void fragment()
{
	vec4 color_base = COLOR;
	vec4 texture_color = texture(albedo, UV);
	vec4 normal_color = texture(normal, UV);
	ALBEDO = (texture_color).rgb;
	ALPHA = texture_color.a;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor;
	NORMAL_MAP = (normal_color).rgb;
	
}

