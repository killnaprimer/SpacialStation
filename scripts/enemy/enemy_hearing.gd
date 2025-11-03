extends Node3D
class_name EnemyHearing
@export var hearing_strength : float = 1.0
signal on_sound_heared( pos : Vector3)

func _ready() -> void:
	GameManager.connect("on_sound", on_sound)

func on_sound(pos : Vector3, distance : float):
	print("SENDING")
	if (global_position - pos).length() < distance * hearing_strength:
		emit_signal("on_sound_heared", pos)
