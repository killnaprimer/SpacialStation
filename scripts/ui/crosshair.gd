extends Control
class_name Crosshair

@export var base_offset : float = 8.0
@export var offset_strength : float = 1.0

@onready var crosshair_t: TextureRect = $crosshair_t
@onready var crosshair_b: TextureRect = $crosshair_b
@onready var crosshair_r: TextureRect = $crosshair_r
@onready var crosshair_l: TextureRect = $crosshair_l

func set_crosshairs():
	var new_offset : float = base_offset * offset_strength
	crosshair_t.position = Vector2(-base_offset, -new_offset - base_offset)
	crosshair_b.position = Vector2(-base_offset, new_offset - base_offset)
	crosshair_r.position = Vector2(new_offset + base_offset, -base_offset)
	crosshair_l.position = Vector2(base_offset - new_offset, -base_offset)

func _process(delta: float) -> void:
	set_crosshairs()
	global_position = get_global_mouse_position()

func set_spread(spread : float):
	offset_strength = 1 + (spread/5)
	
