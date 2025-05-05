extends Node
class_name level

func _log(msg: String, type: String, function_name: String):
	CC3D.log(msg, type, self, function_name)

func _ready():
	var __log = func(msg, type := "INFO"):
		_log(msg, type, "_ready")
	__log.call("Level initalizing")
