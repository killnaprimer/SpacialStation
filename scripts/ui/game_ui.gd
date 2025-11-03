extends Control
class_name GameUI
@onready var inventory: InventoryPanel = $Inventory
@onready var cursor: Crosshair = $Crosshair
@onready var character_panel: CharacterPanel = $Character

func _ready() -> void:
	GameManager.ui = self

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		inventory.visible = !inventory.visible
