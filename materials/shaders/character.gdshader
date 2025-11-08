shader_type spatial;
render_mode blend_mix, cull_disabled, depth_draw_opaque, depth_prepass_alpha;
uniform sampler2D albedo_texture : source_color, filter_nearest;
uniform sampler2D normal_map : hint_normal, filter_nearest;
uniform bool flashing = false;
uniform float normal_strength = 0.2;
uniform bool billboard = true;

void fragment() {
    vec4 tex_color = texture(albedo_texture, UV);
	vec4 normal_color = texture(normal_map, UV);
    NORMAL_MAP = (normal_color).rgb;
	ALPHA = tex_color.a;
	if (flashing) {
		ALBEDO = vec3(1,1,1);
		EMISSION  = tex_color.rgb * COLOR.rgb;
	} else {
		ALBEDO = tex_color.rgb * COLOR.rgb;
		EMISSION  = tex_color.rgb * COLOR.rgb * 0.1;
	}



}

void vertex() {
	if (billboard) {
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	NORMAL = normalize(NORMAL * normal_strength);
	}
}