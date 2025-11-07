extends Node3D
class_name EnemyGunHolder

@export var gun : Gun
@export var melee : Melee
@export var aiming_offset : Vector3 = Vector3(0,0.7,0)
@export var reload_time : float = 1.5


var raycast : RayCast3D
var target : Node3D
var tick : int = 0
const tick_max : int = 5
var reload_timer : Timer
var is_reloading : bool
var has_gun : bool
var has_melee : bool

signal on_melee()
signal on_shoot()
signal on_target_dir(dir : float)
#signal on_reload(reloading : bool)

func _ready() -> void:
	raycast = RayCast3D.new()
	add_child(raycast)
	raycast.collision_mask = 1
	tick = randi_range(0, tick_max)
	if gun:
		has_gun = true
		make_loot_gun()
		gun.connect("on_bullet_spent", on_bullet_spent)
		reload_timer = Timer.new()
		add_child(reload_timer)
		reload_timer.one_shot = true
		reload_timer.connect("timeout", finish_reload)
	if melee:
		has_melee = true

func get_target_dir() -> float:
	if !target : return 0
	var dir = (global_position - target.global_position).normalized()
	return dir.z

func _physics_process(_delta: float) -> void:
	emit_signal("on_target_dir", get_target_dir())
	if tick <= 0:
		if target:
			look_at(target.global_position + aiming_offset)
			if has_melee and (target.global_position - global_position).length() < 2.5:
				if melee.hit(): emit_signal("on_melee")
			elif has_los() and has_gun :
				if gun.fire(): emit_signal("on_shoot")
			
			tick = tick_max
	else:
		tick -= 1

func has_los() -> bool:
	raycast.target_position = raycast.to_local(target.global_position + aiming_offset)
	raycast.force_raycast_update()
	return !raycast.is_colliding()

func make_loot_gun():
	var loot : LootGun = LootGun.new()
	loot.ammo_count = gun.mag_size
	loot.mag_size = gun.mag_size
	gun.loot = loot

func reload():
	if reload_timer.is_stopped():
		reload_timer.start(reload_time)
		is_reloading = true

func finish_reload():
	gun.reload_bullets()
	is_reloading = false

func on_bullet_spent(ammo_count : int, _mag_size : int):
	if ammo_count <= 0: reload()
