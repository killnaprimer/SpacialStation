extends Node3D
class_name MouseAim
@export var camera: Camera3D
@export var max_vertical_angle: float = 45.0
@export var min_vertical_angle: float = -15.0
@export var y_offset : float = 0.5

var ray: RayCast3D

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = get_viewport().get_camera_3d()
	#make_line()

func update_aim():
	var aim_pos = get_aim_point()
	
func get_aim_point() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var dir = camera.project_ray_normal(mouse_pos)
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, from + dir * 1000)
	
	# Prioritize hitting enemies
	query.collision_mask = 1
	
	var result = space_state.intersect_ray(query)
	if result:
		return result.position
	
	# Fallback: point in world space
	return from + dir * 50

func get_aim_point_simple() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var direction = camera.project_ray_normal(mouse_pos)
	var plane = Plane(Vector3.UP, global_position.y)
	var aim_point = plane.intersects_ray(from, direction)
	return aim_point if aim_point else global_position
	return Vector3.ZERO

func get_ray_point(pos : Vector3) -> Vector3:
	if !ray: ray = RayCast3D.new()
	add_child(ray)
	ray.global_position = pos + Vector3(0,10,0)
	ray.target_position = Vector3(0,-12, 0)
	ray.force_raycast_update()
	if ray.is_colliding():
		return ray.get_collision_point()
	return Vector3.ZERO
