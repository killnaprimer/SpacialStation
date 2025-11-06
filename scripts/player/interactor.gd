extends Area3D
var selected_interactive : Node3D
@onready var cursor: Label3D = $cursor

func _ready() -> void:
	connect("body_entered", on_body_entered)
	connect("body_exited", on_body_exited)
	
func on_body_entered(_body : Node3D) -> void:
	print(_body.name + " entered")
	pick_closest_body()
	
func on_body_exited(_body : Node3D) -> void:
	print(_body.name + " exited")
	pick_closest_body()

func pick_closest_body():
	var bodies = get_overlapping_bodies()
	var chosen_body : Node3D = null
	for body in bodies:
		if body.is_in_group("interactive"):
			if !chosen_body: chosen_body = body
			elif (body.global_position - owner.global_position).length() < (chosen_body.global_position - owner.global_position).length():
				chosen_body = body
	selected_interactive = chosen_body
			
func _process(_delta: float) -> void:
	if selected_interactive:
		GameManager.ui.inventory.is_interactive = false
		cursor.modulate.a = 1
		cursor.global_position = selected_interactive.global_position
		if Input.is_action_just_pressed("use"): interact()
	else:
		cursor.modulate.a = 0
		GameManager.ui.inventory.is_interactive = true

func interact():
	if selected_interactive is Pickup:
		Inventory.add_loot(selected_interactive.loot)
		selected_interactive.queue_free()
