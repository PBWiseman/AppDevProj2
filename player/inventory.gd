extends Node

var keys : int = 0

var keyCount : int :
	get:
		return keys
	set(value):
		keys = value
		if keys == 3:
			#Find the node in the scene tree with the name "Door"
			var game = get_tree().get_current_scene()
			var door = game.get_node("Level/Door")
			door.destroy()
