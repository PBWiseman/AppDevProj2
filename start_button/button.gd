extends Button
var button_pressed_sprite
var button_up_sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_pressed_sprite = load("res://start_button/button_pressed.png")
	button_up_sprite = load("res://start_button/button_up.png")
	pass # Replace with function body.


func _on_pressed() -> void:
	load_new_level("res://level/level.tscn")
	get_parent().queue_free()
	pass # Replace with function body.


func _on_button_down() -> void:
	self.icon = button_pressed_sprite
	pass # Replace with function body.


func _on_button_up() -> void:
	self.icon = button_up_sprite
	pass # Replace with function body.


func load_new_level(level_path: String) -> void:
	var level_scene = load(level_path)
	if level_scene:
		var level_instance = level_scene.instantiate()
		get_tree().root.add_child(level_instance)
		get_tree().current_scene = level_instance
	else:
		print("Failed to load level: ", level_path)