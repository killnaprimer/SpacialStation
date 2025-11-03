extends Node
class_name EnemyAI
@export var target : Node3D
@export var enemy : Enemy

var sound_pos : Vector3
var current_pp : int
var tick : int = 0
const tick_max : int = 5
var last_target_pos : Vector3 = Vector3.ZERO
var flank_time : float
var tick_time_total : float
func _ready() -> void:
	await get_tree().process_frame
	enemy.movement.set_target_position(enemy.patrol_points[current_pp].global_position)

func _physics_process(delta: float) -> void:
	if tick < tick_max:
		tick += 1
		return
	tick = 0
	
	if target: chase_target()
	elif sound_pos: check_sound()
	else: patrol
	
func chase_target():
	if (target.global_position - enemy.global_position).length() > 12:
		enemy.movement.set_target_position(target.global_position)
		return
	if !last_target_pos or (target.global_position - last_target_pos).length() > 77:
		enemy.movement.set_target_position(target.global_position)
		enemy.movement.flank_target()
		last_target_pos = target.global_position
		flank_time = 0

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
	target = sighted_target
	enemy.gun_holder.target = target

func on_sound_heared(pos : Vector3):
	sound_pos = pos
