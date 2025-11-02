extends Node3D
class_name EnemyGunHolder

@export var gun : Gun

var target : Node3D

func _physics_process(delta: float) -> void:
	if target:
		look_at(target.global_position + Vector3(0,0.7,0))
		gun.fire()
