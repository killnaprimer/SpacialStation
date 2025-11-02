extends Node3D
class_name Gun
@export var bullet_ref : PackedScene
#Recoil
@export var spread_gain : float
@export var spread_max : float
@export var spread_min : float

func fire():
	
	var bullet : Bullet = bullet_ref.instantiate()
	GameManager.get_world().add_child(bullet)
	bullet.global_position = global_position
	bullet.linear_velocity = -global_transform.basis.z*50
	
