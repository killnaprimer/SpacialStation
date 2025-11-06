shader_type spatial;
render_mode blend_mix, cull_disabled;
uniform sampler2D albedo_texture : source_color, filter_nearest;
uniform sampler2D normal_map : hint_normal, filter_nearest;

void fragment() {
    vec4 tex_color = texture(albedo_texture, UV);
	vec4 normal_color = texture(normal_map, UV);
    ALBEDO = tex_color.rgb * COLOR.rgb;
    ALPHA = tex_color.a;
	NORMAL_MAP = (normal_color).rgb;
}

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}