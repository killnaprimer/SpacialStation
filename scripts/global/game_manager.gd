extends Node

var player : CharacterBody3D
var camera : PlayerCamera
var ui : GameUI

func get_camera()-> PlayerCamera:
	return camera

func get_world() -> Node3D:
	return player.get_parent_node_3d()

func damage(node : Node3D):
	if node.has_node("health"):
		node.get_node("health").take_dmg()
