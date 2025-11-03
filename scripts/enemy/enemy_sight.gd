extends Area3D
class_name EnemySight
signal target_sighted(target : Node3D)
@export var height_offset : Vector3 = Vector3(0,0.5,0)
var ray : RayCast3D
var tick : int = 10

func _ready() -> void:
	#connect("body_entered",on_target_sighted)
	ray = RayCast3D.new()
	add_child(ray)
	ray.position = height_offset
	tick = randi_range(1,9)

func _physics_process(delta: float) -> void:
	tick -= 1
	if tick < 0:
		check_targets()
		tick = 10
	
func on_target_sighted(target : Node3D):
	ray.target_position = to_global(target.global_position) + height_offset
	ray.force_raycast_update()
	if !ray.is_colliding():
		emit_signal("target_sighted", target)

func check_targets():
	var possible_targets = get_overlapping_bodies()
	for tg in possible_targets:
		if tg is Character:
			on_target_sighted(tg)
