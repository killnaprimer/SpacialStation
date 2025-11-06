@tool
extends Sprite3D
@export var normal_map : Texture2D
var initial_color : Color
var tween : Tween

func _ready() -> void:
	initial_color = modulate
	connect("texture_changed", adjust_shaders)
	adjust_shaders()
	

func on_damage():
	tween = create_tween()
	set_flashing(true)
	tween.tween_property(self, "modulate", Color.WHITE, 0.03)
	tween.tween_property(self, "modulate", initial_color, 0.04)
	tween.tween_callback(set_flashing.bind(false))

func adjust_shaders():
	print("CHANGE TEXTURE")
	if material_overlay: material_overlay = material_overlay.duplicate()
	if material_override: material_override = material_override.duplicate()
	var std_mat = material_overlay as StandardMaterial3D
	std_mat.set("albedo_texture", texture)
	var shader_mat = material_override as ShaderMaterial
	shader_mat.set_shader_parameter("albedo_texture", texture)
	shader_mat.set_shader_parameter("normal_map", normal_map)
	
func set_flashing(is_flashing : bool):
	var shader_mat = material_override as ShaderMaterial
	shader_mat.set_shader_parameter("flashing", is_flashing)
