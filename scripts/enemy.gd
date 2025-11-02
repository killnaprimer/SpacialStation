extends CharacterBody3D
class_name Enemy

@export var movement : EnemyMovement
@export var ai : EnemyAI
@export var navigation : NavigationAgent3D
@export var patrol_points : Array[PatrolPoint]

func _ready() -> void:
	movement.enemy = self
	movement.nav = navigation
	ai.enemy = self
