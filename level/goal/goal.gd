extends Sprite2D

const SPEED = 0.25
const MAX_BOUNCE = 20.0
var moved = 0.0
var direction = -1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Move the goal up and down a little
	position.y += SPEED * direction
	moved += SPEED * direction
		
	if abs(moved) >= MAX_BOUNCE or moved == 0:
		direction *= -1.0
	

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.name == "Player":
		get_node("../CanvasLayer/SpeedrunTimer").stop_timer()
		queue_free()