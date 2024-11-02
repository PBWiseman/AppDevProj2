extends Node

var keys : int = 0

var keyCount : int :
	get:
		return keys
	set(value):
		keys = value
		var game = get_tree().get_current_scene()
		#get all spawner nodes
		var spawners = game.get_node("Level/Spawners").get_children()
		match keys:
			3:
				game.get_node("Level/Door").destroy()
				for spawner in spawners:
					spawner.stage(2)
			6:
				game.get_node("Level/Door2").destroy()
				for spawner in spawners:
					spawner.stage(3)
			9:
				game.get_node("Level/Door3").destroy()
				for spawner in spawners:
					spawner.stage(4)