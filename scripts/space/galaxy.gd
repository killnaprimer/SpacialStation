extends Node
@export var galaxy_size : float = 4000
var vectors : Array [Vector2]
var offset : float = 4500

func _ready() -> void:
	var planets = get_children()
	for planet in planets:
		var temp_pos = get_planet_pos()
		vectors.append(temp_pos)
		planet.global_position = Vector3(temp_pos.x, randf_range(-1500,-250), temp_pos.y)
		print(planet.global_position)

func get_planet_pos() -> Vector2:
	var pos : Vector2 = Vector2(randf_range(-galaxy_size,galaxy_size),randf_range(-galaxy_size,galaxy_size))
	if vectors.is_empty() : return pos
	for i in vectors.size()*3:
		var pos_good : bool
		for v in vectors:
			pos_good = (v - pos).length() > offset and pos
		if pos_good: return pos
		pos = Vector2(randf_range(-galaxy_size,galaxy_size),randf_range(-galaxy_size,galaxy_size))
	return Vector2.ZERO
