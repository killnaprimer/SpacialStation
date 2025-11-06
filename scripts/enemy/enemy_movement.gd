extends Node
class_name EnemyMovement
@export var movement_speed : float = 2.5
@export var roll_speed : float = 15
@export var roll_time : float = 0.5
@export var roll_cooldown : float = 1.0

var enemy : Enemy
var nav : NavigationAgent3D
var is_moving: bool = false

var target_position: Vector3
var flanking : bool = false
var flank_size : float = 1.5

var rolling : bool = false
var roll_time_left : float = 0
var roll_vector : Vector3
var roll_timer : Timer

func set_target_position(new_target: Vector3):
	target_position = new_target
	nav.target_position = target_position
	is_moving = true

func _ready() -> void:
	roll_timer = Timer.new()
	add_child(roll_timer)
	roll_timer.one_shot = true

func _physics_process(_delta: float) -> void:
	if rolling:
		do_roll(_delta)
		return
	if !is_moving: return
	if nav.is_navigation_finished():
		is_moving = false
		return
	var next_position = nav.get_next_path_position()
	var direction = (next_position - enemy.global_position).normalized()
	enemy.velocity = direction * movement_speed
	enemy.move_and_slide()

#region Flanking

func flank_target( mult : float = 1.0):
	flank_size = (target_position - enemy.global_position).length() / 6
	flank_size = clamp(flank_size, 0.75, 1.5) * mult
	var flank_point = _find_valid_flank_point()
	if flank_point:
		nav.target_position = flank_point
		is_moving = true
	else:
		nav.target_position = target_position
		is_moving = true

func _find_valid_flank_point() -> Vector3:
	var target_pos = target_position
	var strategies = [
		_try_side_flank,      # Left/right of target
		_try_circle_flank,    # Circle around
		_try_behind_flank     # Behind target
	]
	for strategy in strategies:
		var point = strategy.call(target_pos)
		if point and _is_position_reachable(point):
			return point
	return Vector3.ZERO
	
func _try_side_flank(target_pos : Vector3) -> Vector3:
	var side = 1.0 if randf() > 0.5 else -1.0
	return target_pos + Vector3(randf_range(3.0, 6.0) * flank_size * side, 0, randf_range(-2.0, 2.0))
	
func _try_circle_flank(target_pos: Vector3) -> Vector3:
	var angle = randf_range(0, TAU)
	var distance = randf_range(4.0, 7.0) * flank_size
	return target_pos + Vector3(sin(angle) * distance, 0, cos(angle) * distance)
	
func _try_behind_flank(target_pos: Vector3) -> Vector3:
	var to_target = (target_pos - enemy.global_position).normalized()
	return target_pos - to_target * randf_range(3.0, 6.0) * flank_size

func _is_position_reachable(test_point: Vector3) -> bool:
	var map_rid = nav.get_navigation_map()
	var closest_point = NavigationServer3D.map_get_closest_point(map_rid, test_point)
	return closest_point.distance_to(test_point) < 1.5
	

	
#endregion

func start_roll(avois_pos : Vector3):
	if rolling: return
	if !roll_timer.is_stopped(): return
	roll_vector = get_roll_direction(avois_pos) * roll_speed
	rolling = true
	roll_time_left = roll_time

func get_roll_direction(avoid_pos : Vector3):
	var direction : Vector3 = (enemy.global_position - avoid_pos).normalized()
	var random_vector: Vector3
	if randf() > 0.5: random_vector = Vector3.UP
	else: random_vector = Vector3(0, 1, 0.001)
	var perpendicular: Vector3 = direction.cross(random_vector).normalized()
	if randf() > 0.5: perpendicular = -perpendicular
	return perpendicular

func do_roll(delta : float):
	roll_time_left -= delta
	var t : float = roll_time_left / roll_time
	var speed_mod : float = t * (2.0-t)
	enemy.velocity.x = roll_vector.x * speed_mod
	enemy.velocity.z = roll_vector.y * speed_mod
	enemy.move_and_slide()
	if roll_time_left <= 0:
		rolling = false
		roll_timer.start(roll_cooldown)
