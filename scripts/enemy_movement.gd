extends Node
class_name EnemyMovement
@export var movement_speed : float = 2.5
var enemy : Enemy
var nav : NavigationAgent3D
var is_moving: bool = false

var target_position: Vector3


func set_target_position(new_target: Vector3):
	target_position = new_target
	nav.target_position = target_position
	is_moving = true

func _physics_process(delta: float) -> void:
	if !is_moving: return
	if nav.is_navigation_finished():
		is_moving = false
		return
	var next_position = nav.get_next_path_position()
	var direction = (next_position - enemy.global_position).normalized()
	enemy.velocity = direction * movement_speed
	enemy.move_and_slide()
