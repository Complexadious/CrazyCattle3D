extends Node3D

func _log(msg: String, type: String, function_name: String):
	CC3D.log(msg, type, self, function_name)

func _ready() -> void:
	var __log = func(msg, type := "INFO"):
		_log(msg, type, "_ready")
	__log.call("Lobby ready ran!", "INFO")
	
