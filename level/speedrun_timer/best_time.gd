extends Label

var best_time: float = 0.0
var save_path = "user://save_data.txt"

func _ready() -> void:
	best_time = load_best_time()
	print_time(best_time, false)

func load_best_time() -> float:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var saved_value = file.get_line().to_float()
			file.close()
			return saved_value
	return 0.0  # Default value if file doesn't exist

func save_best_time(value: float) -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(str(value))
		file.close()

func check_best_time(time: float) -> void:
	if time < best_time or best_time == 0.0:
		best_time = time
		print_time(best_time, true)
		save_best_time(best_time)
	else:
		print_time(best_time, false) #Resetting new best time message

func print_time(time: float, new: bool) -> void:
	if time == 0.0:
		text = "Best Time: None"
		return
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 100)
	if new:
		text = "New Best Time! %02d:%02d:%02d" % [minutes, seconds, milliseconds]
	else:
		text = "Best Time: %02d:%02d:%02d" % [minutes, seconds, milliseconds]