shader_type spatial;
render_mode blend_mix, depth_draw_never, cull_back, depth_test_disabled;
stencil_mode read, compare_equal, 1;


uniform sampler2D albedo_texture : source_color, filter_nearest;
uniform bool flashing = false;


void fragment() {
    vec4 tex_color = texture(albedo_texture, UV);
	ALBEDO = tex_color.rgb * COLOR.rgb;
	ALPHA *= tex_color.a * tex_color.a;
}

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}