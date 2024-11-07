extends Node2D

var checkpoint_position: Vector2
var player: Node2D  # Reference to the player node
var lastRespawnTime: int = 0
const RESPAWN_DELAY = 1000
var start_position: Vector2
var node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	start_position = player.position
	checkpoint_position = player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Get the bottom of the screen
	if Input.is_action_pressed("respawn") or player.position.y > 1000: #If fallen or respawn key hit
		respawn()
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func set_checkpoint(new_checkpoint_position: Vector2) -> void:
	checkpoint_position = new_checkpoint_position

func respawn() -> void:
	if Time.get_ticks_msec() - lastRespawnTime < RESPAWN_DELAY:
		return
	lastRespawnTime = Time.get_ticks_msec()
	player.position = checkpoint_position
	node = get_node("../../CanvasLayer/SpeedrunTimer")
	node.add_time(1.0)

func reset() -> void:
	player.position = start_position
	checkpoint_position = start_position
