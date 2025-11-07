extends RigidBody3D
class_name Turret

@export var sight : EnemySight
@export var gun_holder : EnemyGunHolder
enum TARGETS {NONE, PLAYER, ENEMY}
@export var target_type : TARGETS

func _ready() -> void:
	match target_type:
		TARGETS.PLAYER:
			gun_holder.gun.target_type = Gun.target_types.PLAYER
			sight.set_collision_mask_value(3, true)
			sight.set_collision_mask_value(4, false)
		TARGETS.ENEMY:
			gun_holder.gun.target_type = Gun.target_types.ENEMY
			sight.set_collision_mask_value(4, true)
			sight.set_collision_mask_value(3, false)


func on_target_sighted(target: Node3D) -> void:
	gun_holder.target = target
