extends RigidBody3D
class_name Bullet
var damage : int = 1
func _ready() -> void:
	connect("body_entered", on_collision)

func on_collision(body : Node):
	GameManager.damage(body, damage)
	queue_free()
