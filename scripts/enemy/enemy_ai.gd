extends Node
class_name EnemyAI
@export var target : Node3D
@export var enemy : Enemy
@export var gun_holder : EnemyGunHolder

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
	flank_time += delta
	
	if tick < tick_max:
		tick += 1
		return
	tick = 0
	if target: chase_target()
	elif sound_pos: check_sound()
	else: patrol()
	
func chase_target():
	var distance : float = (target.global_position - last_target_pos).length()
	
	if !gun_holder.has_gun:
		enemy.movement.set_target_position(target.global_position)
		return
	
	if gun_holder.is_reloading:
		if distance < 5:
			enemy.movement.set_target_position(target.global_position)
			return
		if flank_time > 3:
			enemy.movement.set_target_position(get_combat_pos())
			enemy.movement.flank_target(3)
			flank_time = 0
		return
	
	if distance < 5:
		enemy.movement.set_target_position(get_combat_pos(1,10))
		return
	
	if !last_target_pos or distance > 7 or flank_time > 7:
		enemy.movement.set_target_position(get_combat_pos())
		enemy.movement.flank_target()
		last_target_pos = target.global_position
		flank_time = 0

func get_combat_pos(dist_min : float = 5, dist_max : float = 10) -> Vector3:
	var distance : float = (enemy.global_position - target.global_position).length()
	if distance < dist_min or distance > dist_max:
		return enemy.global_position
	return (enemy.global_position - target.global_position).normalized() * 3 + enemy.global_position

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
	if target:
		if sighted_target is Turret and !target is Turret:
			target = sighted_target
	target = sighted_target
	enemy.gun_holder.target = target
	
func on_sound_heared(pos : Vector3):
	sound_pos = pos

func on_fire_sighted(pos: Vector3) -> void:
	if target: enemy.movement.start_roll(pos)
