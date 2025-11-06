extends Resource
class_name LootItem
@export var loot_name : String
@export var icon : Texture
@export var stack : int
@export var max_stack : int
var equipped : bool

func use():
	print("used " + loot_name)

func get_loot_name() -> String :
	return loot_name
