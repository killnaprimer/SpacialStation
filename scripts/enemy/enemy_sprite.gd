@tool
extends Sprite3D
@export var normal_map : Texture2D
const CHARACTER_SHADER = preload("uid://541fc1k45g4m")
const CHARACTER_XRAY_SHADER = preload("uid://djpop43t0kc30")



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
	set_shaders()
	#if material_overlay: material_overlay = material_overlay.duplicate()
	#if material_override: material_override = material_override.duplicate()
	var overlay = material_overlay as ShaderMaterial
	overlay.set_shader_parameter("albedo_texture", texture)
	var override = material_override as ShaderMaterial
	override.set_shader_parameter("albedo_texture", texture)
	override.set_shader_parameter("normal_map", normal_map)
	
func set_flashing(is_flashing : bool):
	var override = material_override as ShaderMaterial
	override.set_shader_parameter("flashing", is_flashing)

func set_shaders():
	var overlay_mat : ShaderMaterial = ShaderMaterial.new()
	overlay_mat.shader = CHARACTER_XRAY_SHADER
	material_overlay = overlay_mat
	var override_mat : ShaderMaterial = ShaderMaterial.new()
	override_mat.shader = CHARACTER_SHADER
	material_override = override_mat
