extends Area3D
class_name EnemySight
signal target_sighted(target : Node3D)
signal fire_sighted(pos : Vector3)

@export var height_offset : Vector3 = Vector3(0,0.5,0)
var ray : RayCast3D
var tick : int = 5

func _ready() -> void:
	#connect("body_entered",on_target_sighted)
	ray = RayCast3D.new()
	add_child(ray)
	ray.position = Vector3.ZERO
	ray.debug_shape_custom_color = Color.RED
	tick = randi_range(1,9)

func _physics_process(_delta: float) -> void:
	tick -= 1
	if tick <= 0:
		check_targets()
		tick = 10
	
func on_target_sighted(target : Node3D):
	ray.target_position = ray.to_local(target.global_position) + height_offset
	ray.force_raycast_update()
	if !ray.is_colliding():
		emit_signal("target_sighted", target)

func on_fire_sighted(pos : Vector3):
	emit_signal("fire_sighted", pos)

func check_targets():
	var possible_targets = get_overlapping_bodies()
	for tg in possible_targets:
		if tg is Player:
			on_target_sighted(tg)
		if tg is RigidBody3D:
			on_fire_sighted(tg.global_position)
