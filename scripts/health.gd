extends Node3D
@export var health : int = 3

func take_dmg(dmg : int = 1):
	health -= dmg
	if health <= 0: die()

func die():
	owner.queue_free() 
