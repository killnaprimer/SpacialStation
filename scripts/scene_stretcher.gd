extends Node

@onready var sub_viewport_container = $SubViewportContainer
@onready var sub_viewport = $SubViewportContainer/SubViewport

func _ready():
	# Set the fixed render resolution
	sub_viewport.size = Vector2i(640, 480)
	
	# DISABLE stretch - this is important!
	sub_viewport_container.stretch = false
	
	# Manually handle the container size
	_update_container_size()
	
	# Connect to handle window resizing
	get_viewport().size_changed.connect(_on_window_resized)

func _on_window_resized():
	_update_container_size()

func _update_container_size():
	# Get the current window size
	var window_size = get_viewport().get_visible_rect().size
	
	# Set the container to fill the window
	sub_viewport_container.size = window_size
	
	# Optional: Center the 640x480 viewport in the container
	var scale_x = window_size.x / 640.0
	var scale_y = window_size.y / 480.0
	var scale = min(scale_x, scale_y)  # Maintain aspect ratio
	
	var scaled_width = 640 * scale
	var scaled_height = 480 * scale
	
	# Center the viewport within the container
	sub_viewport.size = Vector2i(640, 480)
	sub_viewport_container.position = Vector2(
		(window_size.x - scaled_width) * 0.5,
		(window_size.y - scaled_height) * 0.5
	)
	sub_viewport_container.size = Vector2(scaled_width, scaled_height)
