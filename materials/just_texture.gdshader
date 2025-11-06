shader_type spatial;
render_mode blend_mix,
	cull_back,
	depth_prepass_alpha,
	specular_disabled;
stencil_mode write, 1;

uniform sampler2D albedo : source_color, filter_nearest;
uniform sampler2D normal : hint_normal, filter_nearest;
uniform sampler2D emissive : source_color, filter_nearest;
uniform float alpha_scissor : hint_range(0, 1) = 0.5;
uniform bool use_normal = true;
uniform float emissive_str : hint_range(0, 1) = 0.0;

void fragment()
{
	vec4 color_base = COLOR;
	vec4 texture_color = texture(albedo, UV);
	vec4 normal_color = texture(normal, UV);
	vec4 emissive_color = texture(emissive, UV);
	ALBEDO = (texture_color).rgb;
	ALPHA = texture_color.a;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor;
	EMISSION = emissive_color.rgb * emissive_str;
	if (use_normal) {NORMAL_MAP = (normal_color).rgb;}
	
}

