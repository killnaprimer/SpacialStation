extends Sprite3D
var initial_color : Color
var tween : Tween

func _ready() -> void:
	initial_color = modulate

func on_damage():
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.03)
	tween.tween_property(self, "modulate", initial_color, 0.04)
