extends LootItem
class_name LootAmmo

@export var ammo_type : Gun.ammo_types
@export var count : int

func use():
	#start reloading player's gun? if its the right type
	pass

func take_ammo(required_count : int) -> int:
	var return_count : int = clamp(required_count,0,count)
	count -= return_count
	return return_count

func get_loot_name() -> String:
	return loot_name + ":" + str(count)
