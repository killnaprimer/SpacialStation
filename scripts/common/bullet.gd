extends RigidBody3D
class_name Bullet

func _ready() -> void:
	connect("body_entered", on_collision)

func on_collision(body : Node):
	GameManager.damage(body)
	queue_free()
