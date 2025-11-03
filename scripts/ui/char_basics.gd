extends Panel
class_name CharacterPanel

@onready var ammo_text: Label = $MarginContainer/VBoxContainer/ammo_text
@onready var hp_bar: TextProgressBar = $MarginContainer/VBoxContainer/hp_bar
@onready var reload_bar: TextProgressBar = $MarginContainer/VBoxContainer/reload_bar

func set_health(hp : int, max_hp : int):
	pass

func set_ammo(ammo : int, max_ammo : int):
	ammo_text.text = "AMMO : " + str(ammo) + "/" + str(max_ammo)

func set_reloading(is_reloading : bool):
	ammo_text.visible = !is_reloading
	reload_bar.visible = is_reloading

func set_reload_progress(time_left : float, time_total : float):
	reload_bar.set_bar_value(time_left, time_total)
