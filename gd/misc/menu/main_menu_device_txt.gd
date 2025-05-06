extends Label

func _ready() -> void:
	text = "<" + str(OS.get_model_name()) + ">"
