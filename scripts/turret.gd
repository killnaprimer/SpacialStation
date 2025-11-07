extends RigidBody3D
class_name Turret

@export var sight : EnemySight
@export var gun_holder : EnemyGunHolder
@export var health : Vitals
enum TARGETS {NONE, PLAYER, ENEMY}
@export var target_type : TARGETS

func _ready() -> void:
	update_for_target_type()

func update_for_target_type():
	match target_type:
		TARGETS.PLAYER:
			gun_holder.gun.target_type = Gun.target_types.PLAYER
			sight.set_collision_mask_value(3, true)
			sight.set_collision_mask_value(4, false)
		TARGETS.ENEMY:
			gun_holder.gun.target_type = Gun.target_types.ENEMY
			sight.set_collision_mask_value(4, true)
			sight.set_collision_mask_value(3, false)
		TARGETS.NONE:
			gun_holder.target = null
			sight.set_collision_mask_value(4, false)
			sight.set_collision_mask_value(3, false)

func on_target_sighted(target: Node3D) -> void:
	if gun_holder.target:
		if (target.global_position - global_position).length() > (gun_holder.target.global_position - global_position).length():
			return
	gun_holder.target = target

func die():
	target_type = TARGETS.NONE
	add_to_group("interactive")
	update_for_target_type()

func repair():
	remove_from_group("interactive")
	target_type = TARGETS.ENEMY
	health.health = 2 #TODO: Increase base health by INT
	update_for_target_type()
	
	
