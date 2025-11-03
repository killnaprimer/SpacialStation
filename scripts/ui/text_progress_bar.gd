@tool
extends Label
class_name TextProgressBar

@export var header : String = ""
@export var tick_filled : String = "!"
@export var tick_empty : String = "."

@export_category("Values")
@export var tick_interval : float = 1.0
@export var value : float = 5.0
@export var max_value : float = 10.0

var filled_ticks : int
var ticks : int

func set_bar_value(current : float, max : float):
	value = current
	max_value = max
	var ticks = int (max / tick_interval)
	var filled_ticks = int (current / tick_interval)
	var new_text : String = header + " "
	for tick in ticks:
		if tick < filled_ticks: new_text += tick_filled
		else: new_text += tick_empty
	text = new_text

func _process(delta: float) -> void:
	set_bar_value(value, max_value)
