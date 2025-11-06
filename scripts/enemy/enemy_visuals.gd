extends Node3D
@onready var sprite: Sprite3D = $Sprite3D
@onready var anim: AnimationPlayer = $AnimationPlayer

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

func _ready() -> void:
	anim.connect("animation_finished", on_anim_finished)

func _process(_delta: float) -> void:
	var velocity = enemy.velocity
	if velocity.z > 0:
		sprite.flip_h = false
	if velocity.z < 0:
		sprite.flip_h = true

func play_melee():
	anim.play("bite")

func on_anim_finished(_name : StringName):
	anim.play(a_idle)
