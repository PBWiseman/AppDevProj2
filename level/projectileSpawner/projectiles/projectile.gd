extends Node2D

#Importing the Direction enum from the direction.gd script
const Direction = preload("res://level/projectileSpawner/direction.gd").Direction

const TIMEOUT = 30.0
const SPEED = 300

var direction: Direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match direction:
		Direction.UP:
			rotation_degrees = 0
		Direction.DOWN:
			rotation_degrees = 180
		Direction.LEFT:
			rotation_degrees = 270
		Direction.RIGHT:
			rotation_degrees = 90
		Direction.UPLEFT:
			rotation_degrees = 315
		Direction.UPRIGHT:
			rotation_degrees = 45
		Direction.DOWNLEFT:
			rotation_degrees = 225
		Direction.DOWNRIGHT:
			rotation_degrees = 135
		null:
			print("No direction set")
	var timer = Timer.new()
	timer.wait_time = TIMEOUT
	timer.autostart = true
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

# Function to handle the Timer timeout signal
func _on_Timer_timeout() -> void:
	#Destroy the projectile after the timeout
	queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move the projectile in the direction it is facing
	position += Vector2.UP.rotated(rotation) * delta * SPEED

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.name == "Player":
		body.get_node("Respawning").respawn()
