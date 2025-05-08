extends AudioStreamPlayer
class_name WorldBackroundAudio

@export var loop : bool = true

func _ready() -> void:
	if loop:
		connect("finished", play)
