extends Control
class_name GameUI
@onready var inventory: InventoryPanel = $Inventory

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		inventory.visible = !inventory.visible
