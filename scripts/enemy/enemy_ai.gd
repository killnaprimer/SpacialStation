extends Node
class_name EnemyAI
@export var target : Node3D
@export var enemy : Enemy

var sound_pos : Vector3
var current_pp : int
var tick : int = 0
const tick_max : int = 5


func _ready() -> void:
	await get_tree().process_frame
	enemy.movement.set_target_position(enemy.patrol_points[current_pp].global_position)

func _physics_process(delta: float) -> void:
	if tick < tick_max:
		tick += 1
		return
	tick = 0
	
	if target: enemy.movement.set_target_position(target.global_position)
	elif sound_pos: check_sound()
	else: patrol
	
	#if !target: patrol()
	#else: enemy.movement.set_target_position(target.global_position)

func check_sound():
	if (enemy.global_position - sound_pos).length() < 2:
		sound_pos = Vector3.ZERO
	else:
		enemy.movement.set_target_position(sound_pos)

func patrol():
	if enemy.patrol_points.is_empty(): return
	if (enemy.patrol_points[current_pp].global_position - enemy.global_position).length() < 1.2:
		current_pp += 1
		if current_pp >= enemy.patrol_points.size(): current_pp = 0
		enemy.movement.set_target_position(enemy.patrol_points[current_pp].global_position)

func on_target_sighted(sighted_target : Node3D):
	print(name + " has found a target!")
	target = sighted_target
	enemy.gun_holder.target = target

func on_sound_heared(pos : Vector3):
	sound_pos = pos
