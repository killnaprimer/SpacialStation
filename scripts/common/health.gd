extends Node3D
@export var health : int = 3
@export var max_health : int = 3
@export var connect_to_ui: bool

signal on_health_changed(current : int, max : int)

func _ready() -> void:
	health = max_health
	await get_tree().process_frame
	if connect_to_ui:
		connect("on_health_changed", GameManager.ui.character_panel.set_health)
		emit_signal("on_health_changed",health, max_health)

func take_dmg(dmg : int = 1):
	health -= dmg
	if health <= 0: die()
	if connect_to_ui: emit_signal("on_health_changed",health, max_health)

func die():
	owner.queue_free() 
