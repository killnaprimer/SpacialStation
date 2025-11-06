extends Panel
class_name InventoryPanel
const LOOT_ITEM = preload("res://scenes/ui/loot_item.tscn")
@onready var list: VBoxContainer = $MarginContainer/list

enum mods {NORMAL, CRAFTING}

var loot_items : Array[LootItemRow]
var current : int = 0
var is_interactive : bool = true

func fill_from_inventory():
	for row in loot_items: row.queue_free()
	loot_items.clear()
	for loot in Inventory.loot_items:
		var loot_row : LootItemRow = LOOT_ITEM.instantiate()
		loot_row.set_loot(loot)
		list.add_child(loot_row)
		loot_items.append(loot_row)
	set_highlighted_item()
		#visible = false
		
func _ready() -> void:
	Inventory.connect("on_loot_changed", fill_from_inventory)
	fill_from_inventory()
	set_highlighted_item()

func _process(_delta: float) -> void:
	if !visible: return
	if !is_interactive: return
	if Input.is_action_just_pressed("scroll_up"): scroll(true)
	if Input.is_action_just_pressed("scroll_down"): scroll(false)
	if Input.is_action_just_pressed("use"): use_item()

func scroll(up : bool):
	if up: current = max(0, current-1)
	else: current = min(loot_items.size()-1, current + 1)
	update_loot()

func set_highlighted_item():
	for i in loot_items.size():
		loot_items[i].set_highlighted(i == current)

func use_item():
	loot_items[current].on_use()
	update_loot()
	
func update_loot():
	for loot_row in loot_items:
		loot_row.update_labels()
		loot_row.set_equipped()
		set_highlighted_item()
