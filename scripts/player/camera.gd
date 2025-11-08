@tool

extends Camera3D
class_name PlayerCamera

@export var player : Node3D
@export var offset : Vector3
@export var scroll_zoom : bool
@export var distance_range : Vector2 = Vector2(25, 150)
var tween : Tween
var base_fov : float

func _ready() -> void:
	base_fov = fov
	GameManager.camera = self

func _process(delta: float) -> void:
	if player:
		if player is RigidBody3D:
			var new_position = player.global_position + offset.normalized() * calculate_distance_factor(player)
			global_position = lerp(global_position, new_position, delta * 25)
		else:
			global_position = player.global_position + offset
	

func make_tween():
	#if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, "fov", base_fov - 4, 0.05).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "fov", base_fov, 0.1).set_ease(Tween.EASE_OUT)

func calculate_distance_factor(body: RigidBody3D):
	var fac = body.linear_velocity.length()/ 500
	return lerpf(distance_range.x, distance_range.y, fac)

func snap():
	var new_position = player.global_position + offset.normalized() * calculate_distance_factor(player)
	global_position = new_position
