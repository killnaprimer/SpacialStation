extends Node3D
class_name Gun
#@export var bullet_ref : PackedScene
const bullet_ref = preload("res://scenes/prefabs/bullet.tscn")
#Recoil

@export_category("Basics")
@export var base_spread : float = 1.0
@export var bullet_count : int = 1
@export var firing_cooldown : float = 0.5
@export var bullet_speed: float = 50

@export_category("Type")
@export var burst_type: burst_types
enum burst_types {NO, SHOTGUN, BURST}
@export var target_type: target_types
enum target_types {ENEMY, PLAYER, BOTH}

@export_category("Recoil")
@export var recoil_gain : float = 0.2
@export var recoil_base : float = 0.5
@export var recoil_recovery : float = 0.2
var recoil : float = 0

@export_category("Shotgun Spread")
@export var spread_gain : float = 5.0

var timer : Timer
var can_fire : bool = true :
	set(value):
		can_fire = value
		if !value:
			timer.start(firing_cooldown)
var burst_timer : Timer
var burst_count_left : int

signal on_fire()

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", reset_fire)
	# For burst
	burst_timer = Timer.new()
	burst_timer.one_shot = true
	add_child(burst_timer)
	burst_timer.connect("timeout", fire_burst_single)

func _physics_process(delta: float) -> void:
	recoil -= recoil_recovery * delta
	recoil = clampf(recoil, 0, 1)

func fire():
	if !can_fire: return
	match burst_type:
		burst_types.NO: fire_single()
		burst_types.SHOTGUN: fire_multiple()
		burst_types.BURST: fire_burst()
	can_fire = false
	
func fire_multiple():
	var spread : float = 0
	for i in bullet_count:
		var bullet : Bullet =  spawn_bullet()
		var base_direction = -global_transform.basis.z
		var spread_direction = base_direction.rotated(global_transform.basis.y, deg_to_rad(spread + get_base_spread()) )
		bullet.linear_velocity = spread_direction * bullet_speed
		
		if spread == 0: spread += spread_gain
		elif spread < 0: spread = -spread
		else: spread += spread_gain
	recoil += recoil_gain
	emit_signal("on_fire")

func fire_burst():
	can_fire = false
	burst_count_left = bullet_count
	fire_burst_single()

func fire_burst_single():
	fire_single()
	burst_count_left -= 1
	if burst_count_left > 0: burst_timer.start(0.05)
	
func fire_single():
	var bullet : Bullet =  spawn_bullet()
	var base_direction = -global_transform.basis.z
	var spread_direction = base_direction.rotated(global_transform.basis.y, deg_to_rad(get_base_spread()) )
	bullet.linear_velocity = spread_direction * bullet_speed
	recoil += recoil_gain
	emit_signal("on_fire")

func spawn_bullet() -> Bullet:
	var bullet : Bullet = bullet_ref.instantiate()
	GameManager.get_world().add_child(bullet)
	bullet.global_position = global_position
	match target_type:
		target_types.ENEMY: bullet.set_collision_mask_value(4, true)
		target_types.PLAYER: bullet.set_collision_mask_value(3, true)
		target_types.BOTH:
			bullet.set_collision_mask_value(4, true)
			bullet.set_collision_mask_value(3, true)
	return bullet

func get_base_spread():
	var spread = base_spread + (recoil_base * recoil)
	return randf_range(-spread, spread)

func reset_fire(): can_fire = true
