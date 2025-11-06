extends Node3D
class_name Vitals

@export var health : int = 3
@export var max_health : int = 3
@export var connect_to_ui: bool
@export var invul_time: float = 0
var invul_timer : float = 0
var is_invulnerable : bool

signal on_health_changed(current : int, max : int)
signal on_damaged()

func _ready() -> void:
	health = max_health
	await get_tree().process_frame
	if connect_to_ui:
		connect("on_health_changed", GameManager.ui.character_panel.set_health)
		emit_signal("on_health_changed",health, max_health)

func _process(delta: float) -> void:
	if is_invulnerable:
		invul_timer -= delta
		is_invulnerable = invul_timer > 0

func take_dmg(dmg : int = 1):
	if is_invulnerable: return
	health -= dmg
	if invul_time > 0:
		invul_timer = invul_time
		is_invulnerable = true
	if health <= 0: die()
	emit_signal("on_damaged")
	if connect_to_ui: emit_signal("on_health_changed",health, max_health)

func restore_health(heal : int):
	health += heal
	health = clamp(health, 0, max_health)
	if connect_to_ui: emit_signal("on_health_changed",health, max_health)

func set_max_health(new_health : int):
	var health_percent : float = float(health) / float(max_health)
	max_health = new_health
	health = int ( float(max_health) * health_percent )

func die():
	owner.queue_free() 
