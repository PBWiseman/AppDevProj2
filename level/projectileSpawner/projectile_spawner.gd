extends Node2D

var random = RandomNumberGenerator.new()
var projectile = preload("res://level/projectileSpawner/projectiles/projectile.tscn")
var active = false
var timer
#list of stages active in

const Direction = preload("res://level/projectileSpawner/direction.gd").Direction
#Stages active in
@export var stages : Array[int] = []
#Variable for direction I can set in the inspector
@export var direction : Direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random.randomize()
	timer = Timer.new()
	timer.wait_time = random.randf_range(1, 3)
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	stage(1)

# Function to handle the Timer timeout signal
func _on_Timer_timeout() -> void:
	if active:
		#make a projectile and give direction
		var projectile_instance = projectile.instantiate()
		projectile_instance.direction = direction
		add_child(projectile_instance)

	#Random time until next projectile
	timer.wait_time = random.randf_range(1, 3)
	timer.start()

func stage(value: int) -> void:
	print("Stage: ", value)
	print("Stages: ", stages)
	if value in stages:
		active = true
	else:
		active = false