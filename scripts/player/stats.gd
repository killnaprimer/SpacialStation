extends Node
class_name PlayerStats
@export var strength : int = 3
@export var dexterity : int = 3
@export var toughness : int = 3
@export var intellect : int = 3

const stat_cap : int = 10

#STR
func get_recoil_mod(): 
	var factor : float = float(strength) / stat_cap
	return lerpf(3.0, 0.25, factor)

func get_melee_mod() -> int:
	var dmg = ceil(float(strength) / 3)
	return dmg

#DEX
func get_spread_mod() -> float:
	var factor : float = float(dexterity) / stat_cap
	return lerpf( 3.0, 0.25, factor )

func get_reload_mod():
	var factor : float = float(dexterity) / stat_cap
	return lerpf( 2.0, 0.25, factor)

#TOUGH
func get_health() -> int:
	return 1 + toughness

func get_inventory_size():
	return 3 + toughness

#INT
func get_repair_chance() -> float:
	var factor : float = float(intellect) / stat_cap
	return lerpf(0, 1, factor)

func get_repair_health() -> int:
	return intellect
