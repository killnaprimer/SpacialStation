extends CharacterBody3D
class_name Character

@export var speed: float = 5.0

#VISUALS
@export var sprite : Sprite3D
@export var anim : AnimationPlayer

#ROLLING
@export var roll_speed : float = 15.0
@export var roll_time : float = .7
var roll_time_left : float
var is_rolling : bool
var roll_vector : Vector2

#ADJUSTED MOVEMENT
var is_aiming : bool

func _ready() -> void:
	GameManager.player = self

func _physics_process(_delta):
	if is_rolling:
		roll_time_left -= _delta
		var t = roll_time_left / roll_time
		var speed_mod = t * (2-t)
		velocity.x = roll_vector.x * speed_mod
		velocity.z = roll_vector.y * speed_mod
		if roll_time_left <= 0: is_rolling = false
		if get_real_velocity().length() < 0.1 : is_rolling = false
		move_and_slide()
		anim.play("roll")
		return
	
	var input_dir = Input.get_vector("move_back", "move_forward", "move_left","move_right").normalized()
	var speed_mod = 1.0
	if is_aiming: speed_mod = 0.5
	velocity.x = (input_dir.x) * speed * speed_mod
	velocity.z = (input_dir.y) * speed * speed_mod
	
	if velocity.z < 0: sprite.flip_h = true
	if velocity.z > 0: sprite.flip_h = false
	
	if Vector2(velocity.x, velocity.z).length() >0 :
		if !is_aiming: anim.play("run")
		else: anim.play("walk")
	else: anim.play("idle")
	
	move_and_slide()
	if !is_on_floor():
		velocity.y -= 9.8
	else:
		velocity.y = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("roll"):
		roll()

func roll():
	if is_rolling: return
	if Vector2(velocity.x, velocity.z).length() < 0.1 : return
	roll_vector = Vector2(velocity.x, velocity.z).normalized() * roll_speed
	roll_time_left = roll_time
	is_rolling = true
