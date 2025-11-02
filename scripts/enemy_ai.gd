extends Node
class_name EnemyAI
@export var target : Node3D
@export var enemy : Enemy

var current_pp : int

func _ready() -> void:
	await get_tree().process_frame
	enemy.movement.set_target_position(enemy.patrol_points[current_pp].global_position)

func _physics_process(delta: float) -> void:
	if enemy.patrol_points.is_empty(): return
	if (enemy.patrol_points[current_pp].global_position - enemy.global_position).length() < 1.2:
		current_pp += 1
		if current_pp >= enemy.patrol_points.size(): current_pp = 0
		enemy.movement.set_target_position(enemy.patrol_points[current_pp].global_position)
