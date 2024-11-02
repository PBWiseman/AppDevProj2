extends Sprite2D

const SPEED = 0.1
const MAX_BOUNCE = 10.0
var moved = 0.0
var direction = -1.0

func _ready() -> void:
	#Move the key to a random position on its bouncing path
	var bounce_amount = randf_range(0, MAX_BOUNCE/2)
	position.y += bounce_amount * direction
	moved = bounce_amount * direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Move the key up and down a little
	position.y += SPEED * direction
	moved += SPEED * direction
		
	if abs(moved) >= MAX_BOUNCE:
		direction *= -1.0

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.name == "Player":
		var inv = body.get_node("Inventory")
		inv.keyCount += 1
		get_node("../../CanvasLayer/KeyCount").print_keys(inv.keyCount)
		queue_free()
