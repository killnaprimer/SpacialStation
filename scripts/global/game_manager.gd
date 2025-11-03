extends Node

var player : CharacterBody3D
var camera : PlayerCamera
var ui : GameUI
var world : Node3D

func get_camera()-> PlayerCamera:
	return camera

func get_world() -> Node3D:
	if !world: world = player.get_parent_node_3d()
	return world

func damage(node : Node3D):
	if node.has_node("health"):
		node.get_node("health").take_dmg()

signal on_sound(pos : Vector3, dist : float)

func send_sound(pos : Vector3, dist : float):
	emit_signal("on_sound", pos, dist)
