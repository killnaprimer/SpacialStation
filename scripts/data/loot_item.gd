extends Resource
class_name LootItem
@export var loot_name : String

func use():
	print("used " + loot_name)
