@tool

extends Camera3D
class_name PlayerCamera

@export var player : Node3D
@export var offset : Vector3

var tween : Tween
var base_fov : float

func _ready() -> void:
	base_fov = fov
	GameManager.camera = self

func _process(delta: float) -> void:
	if player:
		global_position = player.global_position + offset

func make_tween():
	#if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, "fov", base_fov - 4, 0.05).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "fov", base_fov, 0.1).set_ease(Tween.EASE_OUT)
