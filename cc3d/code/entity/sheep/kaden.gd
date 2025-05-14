extends Sprite2D

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		visible = true
	else:
		visible = false
