extends Area3D
class_name Melee
@export var damage : int
@export var cooldown : float
var cd_timer : Timer
var can_attack : bool = true

const hit_sound = preload("res://sounds/stab_hit.ogg")
const miss_sound = preload("res://sounds/stab_miss.ogg")

func _ready() -> void:
	cd_timer = Timer.new()
	add_child(cd_timer)
	cd_timer.one_shot = true
	cd_timer.connect("timeout", reset_melee)
	

func hit():
	if !can_attack: return
	var bodies = get_overlapping_bodies()
	if bodies.is_empty():
		make_sound(miss_sound)
		return
	make_sound(hit_sound)
	for body in bodies:
		GameManager.damage(body)
	can_attack = false
	cd_timer.start(cooldown)

func reset_melee():
	can_attack = true

func make_sound(sound_ref):
	var sound = SpatialSound.new()
	sound.set_sound(20, sound_ref)
	sound.hearable = false
	GameManager.get_world().add_child(sound)
	sound.global_position = global_position
	sound.start_sound()
