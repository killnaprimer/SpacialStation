extends LootItem
class_name LootGun

@export_category("Basics")
@export var base_spread : float = 1.0
@export var bullet_count : int = 1
@export var firing_cooldown : float = 0.5
@export var bullet_speed: float = 50

@export_category("Type")
@export var burst_type: Gun.burst_types
@export var target_type: Gun.target_types

@export_category("Recoil")
@export var recoil_gain : float = 0.5
@export var recoil_base : float = 10
@export var recoil_recovery : float = 0.2

@export_category("Shotgun Spread")
@export var spread_gain : float = 5.0

func make_gun():
	var gun = Gun.new()
	gun.base_spread = base_spread
	gun.bullet_count = bullet_count
	gun.firing_cooldown =  firing_cooldown
	gun.bullet_speed = bullet_speed
	gun.burst_type = burst_type
	gun.target_type = target_type
	gun.recoil_gain = recoil_gain
	gun.recoil_base = recoil_base
	gun.recoil_recovery = recoil_recovery
	gun.spread_gain = spread_gain
	gun.loot = self
	return gun

func use():
	if GameManager.player.has_node("gun_holder"):
		var gun_holder : GunHolder = GameManager.player.get_node("gun_holder")
		gun_holder.gun.queue_free()
		gun_holder.add_gun(make_gun())
		
