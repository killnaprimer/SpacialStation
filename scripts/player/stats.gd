extends Node
class_name PlayerStats
@export var strength : int = 2
@export var dexterity : int = 2
@export var toughness : int = 2
@export var intellect : int = 2

#STR
func get_recoil_mod(): 
	var factor : float = float(strength) / 5.0
	return lerpf(2.0, 0.5, factor)

func get_melee_mod() -> int:
	var dmg = ceil(float(strength) / 2.0)
	return dmg

#DEX
func get_spread_mod() -> float:
	var factor : float = float(dexterity) / 5.0
	return lerpf( 2.0, 0.5, factor )

func get_reload_mod():
	var factor : float = float(dexterity) / 5.0
	return lerpf( 2.0, 0.5, factor)

#TOUGH
func get_health() -> int:
	return toughness * 2

func get_inventory_size(): pass

#INT
