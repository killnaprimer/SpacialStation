extends Panel
class_name LootItemRow
@export var loot : LootItem
@onready var label: Label = $Label


func on_use():
	loot.use()

func set_highlighted(is_highlighted : bool):
	if is_highlighted : label.modulate = Color.WHITE
	else : label.modulate = Color.DARK_GRAY
	

func set_equipped():
	if loot.equipped:
		label.text = "["+loot.loot_name +"]"
	else:
		label.text = loot.loot_name

func set_loot(_loot : LootItem):
	loot = _loot

func _ready() -> void:
	label.text = loot.loot_name
	
