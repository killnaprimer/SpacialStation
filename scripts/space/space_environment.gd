extends WorldEnvironment
@export var sky_mat : ShaderMaterial
var current_offset : Vector2
var direction : Vector2
@export var spaceship : RigidBody3D

func _ready():
	#print (environment.name)
	#print (environment.sky.name)
	#print (environment.sky.sky_material.name)
	sky_mat = environment.sky.sky_material

func _process(_delta: float) -> void:
	if !spaceship : return
	direction = Vector2(spaceship.linear_velocity.x,spaceship.linear_velocity.z)
	current_offset += direction * 0.0005
	#BAD BUT FINE FOR NOW
	if current_offset.x > 100000 : current_offset.x -=100000
	if current_offset.x <-100000 : current_offset.x += 100000
	if current_offset.y > 100000 : current_offset.y -=100000
	if current_offset.y <-100000 : current_offset.y += 100000
	sky_mat.set_shader_parameter("current_offset", current_offset)
