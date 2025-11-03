extends AudioStreamPlayer3D
class_name SpatialSound
@export var distance : float
var hearable : bool

func _ready() -> void:
	connect("finished", on_ended)

func set_sound(sound_distance : float, sound : AudioStream):
	distance = sound_distance
	max_distance = sound_distance * 2
	stream = sound

func start_sound():
	if hearable :GameManager.send_sound(global_position, distance)
	play()

func on_ended():
	queue_free()
