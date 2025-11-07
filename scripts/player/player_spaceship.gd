extends RigidBody3D

@export_category("Ship Stats")
@export var rotation_speed: float = 3.0
@export var acceleration_force: float = 10.0
@export var max_speed: float = 20.0
@export var drag_factor: float = 0.98

@export_category("Other")
@export var particles : GPUParticles3D

var gas : float = 0

func _ready():
	axis_lock_angular_y = true

func _physics_process(delta):
	handle_input(delta)
	apply_drag()
	clamp_velocity()
	animate_particles()

func handle_input(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	
	if camera:
		# Project mouse to a fixed distance from camera
		var ray_length = 50.0
		var mouse_world = camera.project_position(mouse_pos, ray_length)
		mouse_world.y = global_position.y  # Lock to ship's Y level
		
		var direction_to_mouse = (mouse_world - global_position).normalized()
		
		# Rotate towards mouse
		var target_angle = atan2(direction_to_mouse.x, direction_to_mouse.z)
		rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed * delta)
	
	# Movement (unchanged)
	if Input.is_action_pressed("fire"):
		apply_central_force(transform.basis.z * acceleration_force)
	
	if Input.is_action_pressed("aim"):
		if linear_velocity.length() > 0.1:
			var brake_force = -linear_velocity.normalized() * acceleration_force
			apply_central_force(brake_force)

func apply_drag():
	linear_velocity *= drag_factor

func clamp_velocity():
	var horizontal_velocity = Vector3(linear_velocity.x, 0, linear_velocity.z)
	if horizontal_velocity.length() > max_speed:
		horizontal_velocity = horizontal_velocity.normalized() * max_speed
		linear_velocity.x = horizontal_velocity.x
		linear_velocity.z = horizontal_velocity.z

func animate_particles():
	particles.amount_ratio = clamp(linear_velocity.length() / 100, 0,1)
