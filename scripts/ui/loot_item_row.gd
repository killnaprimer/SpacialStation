extends Panel
class_name LootItemRow
@export var loot : LootItem
@onready var label: Label = $Label

func on_use():
	loot.use()

func set_highlighted(is_highlighted : bool):
	if is_highlighted : label.modulate = Color.RED
	else : label.modulate = Color.WHITE

func set_loot(_loot : LootItem):
	loot = _loot

func _ready() -> void:
	label.text = loot.loot_name
	
