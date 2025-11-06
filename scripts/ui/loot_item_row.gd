extends Panel
class_name LootItemRow
@export var loot : LootItem
@onready var label: Label = $Label
@onready var sub_label: Label = $SubLabel


func on_use():
	loot.use()

func set_highlighted(is_highlighted : bool):
	if is_highlighted : label.modulate = Color.WHITE
	else : label.modulate = Color.DIM_GRAY
	

func set_equipped():
	if loot.equipped:
		label.text = "[ "+loot.get_loot_name() +" ]"
	else:
		label.text = loot.get_loot_name()

func set_loot(_loot : LootItem):
	loot = _loot

func _ready() -> void:
	update_labels()
		
func update_labels():
	label.text = loot.get_loot_name()
	sub_label.text = ""
	label.modulate = Color.DIM_GRAY
	if loot is LootGun:
		if loot.mod:
			sub_label.text += loot.mod.get_loot_name() + " | "
		if loot.ammo_count <= 0:
			sub_label.text += "empty"
