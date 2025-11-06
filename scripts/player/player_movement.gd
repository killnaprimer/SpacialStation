extends Node3D
class_name PlayerMovement
var body : CharacterBody3D

@export var speed: float = 5.0
@export var aiming_speed_mod : float = 0.5
#VISUALS
@export var sprite : Sprite3D
@export var anim : AnimationPlayer

#ROLLING
@export var roll_speed : float = 20.0
@export var roll_time : float = 0.4
var roll_time_left : float
var is_rolling : bool
var roll_vector : Vector2

#ADJUSTED MOVEMENT
var is_aiming : bool

func _ready() -> void:
	body = owner

func _physics_process(_delta):
	if is_rolling:
		roll_time_left -= _delta
		var t : float = roll_time_left / roll_time
		var speed_mod : float = t * (2.0-t)
		body.velocity.x = roll_vector.x * speed_mod
		body.velocity.z = roll_vector.y * speed_mod
		if roll_time_left <= 0: is_rolling = false
		if body.get_real_velocity().length() < 0.1 : is_rolling = false
		anim.play("roll")
	else:
		var input_dir = Input.get_vector("move_back", "move_forward", "move_left","move_right").normalized()
		var speed_mod = 1.0
		if is_aiming: speed_mod = aiming_speed_mod
		body.velocity.x = (input_dir.x) * speed * speed_mod
		body.velocity.z = (input_dir.y) * speed * speed_mod
		
		if body.velocity.z < 0: sprite.flip_h = true
		if body.velocity.z > 0: sprite.flip_h = false
		
		if Vector2(body.velocity.x, body.velocity.z).length() >0 :
			if !is_aiming: anim.play("run")
			else: anim.play("walk")
		else: anim.play("idle")
	
	body.move_and_slide()
	if !body.is_on_floor():
		body.velocity.y -= 9.8
	else:
		body.velocity.y = 0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("roll"):
		roll()

func roll():
	if is_rolling: return
	if Vector2(body.velocity.x, body.velocity.z).length() < 0.1 : return
	roll_vector = Vector2(body.velocity.x, body.velocity.z).normalized() * roll_speed
	roll_time_left = roll_time
	is_rolling = true
