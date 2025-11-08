extends MeshInstance3D
var rot : float
func _ready() -> void:
	#var posx : float = randf_range(-4000,4000)
	#var posz : float = randf_range(-4000,4000)
	#var posy : float = randf_range(-500,-100)
	#global_position = Vector3(posx, posy, posz)
	rot = 3

func _process(delta: float) -> void:
	global_rotation_degrees.y += rot * delta
