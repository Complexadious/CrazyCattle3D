extends Button


func _on_pressed() -> void:
	Input.action_press("pause")
	Input.action_release("pause")
