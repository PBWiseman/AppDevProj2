extends Node2D

var checkpoint_position: Vector2
var player: Node2D  # Reference to the player node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	checkpoint_position = player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("respawn") or player.position.y > 1000: #If fallen or respawn key hit
		respawn()

func set_checkpoint(new_checkpoint_position: Vector2) -> void:
	checkpoint_position = new_checkpoint_position

func respawn() -> void:
	player.position = checkpoint_position