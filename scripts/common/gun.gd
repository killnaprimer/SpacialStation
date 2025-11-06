extends Node3D
class_name Gun
#@export var bullet_ref : PackedScene
const bullet_ref = preload("res://scenes/prefabs/bullet.tscn")
const gun_sound = preload("res://sounds/gun_shoot.ogg")
#Recoil

@export_category("Loot")
@export var loot : LootGun

@export_category("Basics")
@export var base_spread : float = 1.0
@export var bullet_count : int = 1
@export var firing_cooldown : float = 0.5
@export var bullet_speed: float = 50
@export var burst_time : float = 0.05

@export_category("Ammo")
enum ammo_types {PISTOL, SHELL, RIFLE, PLASMA}
@export var ammo_type: ammo_types
@export var mag_size : int

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

@export_category("Gun Sound")
@export var hearable : bool
@export var sound_distance : float = 20.0

var timer : Timer
var can_fire : bool = true :
	set(value):
		can_fire = value
		if !value:
			timer.start(firing_cooldown)
var burst_timer : Timer
var burst_count_left : int
var light : OmniLight3D
var light_tween : Tween
signal on_fire()
signal on_spread_changed(spread : float)
signal on_bullet_spent(ammo : int, max_ammo : int)

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
	
	light = OmniLight3D.new()
	add_child(light)
	light.light_color = Color.DARK_ORANGE
	light.light_energy = 0
	light.omni_range = 15
	light.position = Vector3(0,0, -1.5)
	
func _process(delta: float) -> void:
	recoil -= recoil_recovery * delta
	recoil = clampf(recoil, 0, 1)
	var spread = base_spread + (recoil_base * recoil)
	if burst_type == burst_types.SHOTGUN:
		spread += spread_gain * bullet_count 
	emit_signal("on_spread_changed", spread)

func fire() -> bool:
	if !can_fire: return false
	if loot and loot.ammo_count <= 0: return false
	match burst_type:
		burst_types.NO: fire_single()
		burst_types.SHOTGUN: fire_multiple()
		burst_types.BURST: fire_burst()
	can_fire = false
	return true
	
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
	spend_bullet()
	emit_signal("on_fire")
	make_gun_sound()

func fire_burst():
	can_fire = false
	burst_count_left = bullet_count
	fire_burst_single()

func fire_burst_single():
	fire_single()
	burst_count_left -= 1
	if burst_count_left > 0:
		if !loot or loot.ammo_count > 0:
			burst_timer.start(burst_time)
	
func fire_single():
	var bullet : Bullet =  spawn_bullet()
	var base_direction = -global_transform.basis.z
	var spread_direction = base_direction.rotated(global_transform.basis.y, deg_to_rad(get_base_spread()) )
	bullet.linear_velocity = spread_direction * bullet_speed
	recoil += recoil_gain
	spend_bullet()
	emit_signal("on_fire")
	make_gun_sound()

func spawn_bullet() -> Bullet:
	var bullet : Bullet = bullet_ref.instantiate()
	GameManager.get_world().add_child(bullet)
	bullet.global_position = global_position
	match target_type:
		target_types.ENEMY:
			bullet.set_collision_mask_value(4, true)
			bullet.set_collision_layer_value(3, true)
		target_types.PLAYER:
			bullet.set_collision_mask_value(3, true)
			bullet.set_collision_layer_value(4, true)
		target_types.BOTH:
			bullet.set_collision_mask_value(4, true)
			bullet.set_collision_layer_value(3, true)
	return bullet

func get_base_spread():
	var spread = base_spread + (recoil_base * recoil)
	return randf_range(-spread, spread)

func reset_fire(): can_fire = true

func spend_bullet():
	if !loot: return
	loot.ammo_count -= 1
	emit_signal("on_bullet_spent", loot.ammo_count, loot.mag_size)

func make_gun_sound():
	var sound = SpatialSound.new()
	sound.set_sound(sound_distance, gun_sound)
	sound.hearable = hearable
	GameManager.get_world().add_child(sound)
	sound.global_position = global_position
	sound.start_sound()
	flash()
	
func reload_bullets():
	if !loot: return
	loot.ammo_count = loot.mag_size

func flash():
	light_tween = create_tween()
	light_tween.tween_property(light, "light_energy", 5, 0.1)
	light_tween.tween_property(light, "light_energy", 0, 0.1)
