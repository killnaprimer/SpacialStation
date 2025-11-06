extends Resource
class_name LootItem
@export var loot_name : String
@export var icon : Texture

var equipped : bool

func use():
	print("used " + loot_name)

func get_loot_name() -> String :
	return loot_name
