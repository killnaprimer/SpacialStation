extends CharacterBody3D
class_name Player

@export var gun_holder : GunHolder
@export var movement : PlayerMovement
@export var stats : PlayerStats
@export var health : Vitals

var is_aiming : bool :
	set(value):
		is_aiming = value
		movement.is_aiming = value

func _ready() -> void:
	GameManager.player = self
	health.set_max_health(stats.get_health())
