extends Node3D
class_name Pickup
@export var loot : LootItem
@onready var sprite: Sprite3D = $sprite

func update():
	sprite.texture = loot.icon
