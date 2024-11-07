extends Label

var elapsed_time: float = 0.0
var stopped: bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not stopped:
		elapsed_time += delta
	text = format_time(elapsed_time)

func format_time(time: float) -> String:
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func reset_timer() -> void:
	elapsed_time = 0.0
	text = format_time(elapsed_time)

func stop_timer() -> void:
	stopped = true
	get_node("../BestTime").check_best_time(elapsed_time)

func add_time(time: float) -> void:
	elapsed_time += time
	text = format_time(elapsed_time)

func start_timer() -> void:
	stopped = false