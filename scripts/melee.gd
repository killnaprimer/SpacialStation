extends Area3D
class_name Melee
@export var damage : int
@export var cooldown : float
var cd_timer : Timer
var can_attack : bool = true

func _ready() -> void:
	cd_timer = Timer.new()
	add_child(cd_timer)
	cd_timer.one_shot = true
	cd_timer.connect("timeout", reset_melee)
	

func hit():
	if !can_attack: return
	var bodies = get_overlapping_bodies()
	if bodies.is_empty(): return
	for body in bodies:
		GameManager.damage(body)
	can_attack = false
	cd_timer.start(cooldown)

func reset_melee():
	can_attack = true
