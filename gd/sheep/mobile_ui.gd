extends CanvasLayer

func _ready() -> void:
	var model = OS.get_model_name()
	if !DisplayServer.is_touchscreen_available():
		queue_free()
