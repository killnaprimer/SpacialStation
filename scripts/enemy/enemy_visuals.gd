extends Node3D
@export var sprite: Sprite3D
@export var anim: AnimationPlayer

@export var enemy : CharacterBody3D

@export_category("Animation Keys")
@export var a_idle : String
@export var a_moving : String
@export var a_shoot : String
@export var a_melee : String
@export var a_reload : String
@export var a_dodge : String

@export_category("Misc")
@export var flip_to_direction : bool
@export var debug : bool

var is_playing_action : bool
var is_dodging : bool
var target_dir : float = 0
func _ready() -> void:
	anim.connect("animation_finished", on_anim_finished)

func _process(_delta: float) -> void:
	var velocity = enemy.velocity
	if !is_playing_action:
		if velocity.length() < 0.1:
			anim.play(a_idle)
		else:
			if is_dodging: anim.play(a_dodge)
			else: anim.play(a_moving)
	if target_dir == 0:
		if velocity.z > 0:
			sprite.flip_h = false
		if velocity.z < 0:
			sprite.flip_h = true
	else:
		sprite.flip_h = target_dir > 0

func play_melee():
	if debug : print("PLAY MELEE")
	anim.play(a_melee)
	is_playing_action = true

func play_shoot():
	if debug : print("PLAY SHOOT")
	anim.play(a_shoot)
	is_playing_action = true

func on_anim_finished(_name : StringName):
	if debug : print("BACK TO IDLE")
	is_playing_action = false
	#anim.play(a_idle)

func set_dodge(dodge_active : bool):
	is_dodging = dodge_active

func on_target_dir_change(new_dir : float):
	target_dir = new_dir
