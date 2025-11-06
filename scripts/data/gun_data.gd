extends Resource
class_name GunData

@export_category("Basics")
@export var base_spread : float = 1.0
@export var bullet_count : int = 1
@export var firing_cooldown : float = 0.5
@export var bullet_speed: float = 50
@export var burst_time : float = 0.05

@export_category("Ammo")
@export var ammo_type: Gun.ammo_types
@export var mag_size : int

@export_category("Type")
@export var burst_type: Gun.burst_types
@export var target_type: Gun.target_types

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
