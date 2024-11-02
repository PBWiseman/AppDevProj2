extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_keys(0)

func print_keys(key_count: int) -> void:
	text = "Keys: " + str(key_count)
	match key_count:
		0,1,2:
			text += "/3"
		3,4,5:
			text += "/6"
		6,7,8,9:
			text += "/9"
