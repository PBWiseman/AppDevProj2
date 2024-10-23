extends Sprite2D

var isActive = false

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.name == "Player" and not isActive:
		var respawn = body.get_node("Respawning")
		respawn.set_checkpoint(global_position)
		isActive = true
		changeSprite()
		#Find all other checkpoints in current level and change their sprite to red
		var currentLevel = get_parent()
		for checkpoint in currentLevel.get_children():
			if checkpoint.is_in_group("checkpoints") and checkpoint != self and checkpoint.isActive:
				checkpoint.isActive = false
				checkpoint.changeSprite()
		
		

func changeSprite() -> void:
	if isActive:
		texture = load("res://level/checkpoint/CheckpointGreen.png")
	else:
		texture = load("res://level/checkpoint/CheckpointRed.png")
