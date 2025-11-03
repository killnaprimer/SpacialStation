extends Area3D
class_name EnemySight
signal target_sighted(target : Node3D)
func _ready() -> void:
	connect("body_entered",on_target_sighted)
	
func on_target_sighted(target : Node3D):
	print("SIGHTED " + target.name)
	emit_signal("target_sighted", target)
