extends Resource
class_name LootItem
@export var loot_name : String
var equipped : bool

func use():
	print("used " + loot_name)
