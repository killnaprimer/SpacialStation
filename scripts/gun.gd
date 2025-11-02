extends Node3D
class_name Gun
@export var bullet_ref : PackedScene
#Recoil
@export var spread_gain : float = 5.0
@export var spread_base : float = 1.0

@export var bullet_count : int = 1
@export var cd_time : float = 0.5
var timer : Timer
var can_fire : bool = true :
	set(value):
		can_fire = value
		if !value:
			timer.start(cd_time)

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", reset_fire)

func fire():
	if !can_fire: return
	fire_multiple()
	can_fire = false
	return
	var bullet : Bullet =  spawn_bullet()
	bullet.linear_velocity = -global_transform.basis.z*50
	
func fire_multiple():
	var spread : float = 0
	for i in bullet_count:
		var bullet : Bullet =  spawn_bullet()
		var base_direction = -global_transform.basis.z
		var spread_direction = base_direction.rotated(global_transform.basis.y, deg_to_rad(spread + get_base_spread()) )
		bullet.linear_velocity = spread_direction * 50
		if spread == 0:
			spread += spread_gain
		elif spread < 0:
			spread = -spread
		else:
			spread += spread_gain

func spawn_bullet() -> Bullet:
	var bullet : Bullet = bullet_ref.instantiate()
	GameManager.get_world().add_child(bullet)
	bullet.global_position = global_position
	return bullet

func get_base_spread():
	return randf_range(-spread_base, spread_base)

func reset_fire(): can_fire = true
