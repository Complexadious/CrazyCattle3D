extends Node2D
class_name Menu

@export var internal_name : String

func _log(msg, type: String, function_name: String):
	CC3D.log(msg, type, self, function_name)

func _ready() -> void:
	_log("Menu Class ready ran: " + str(self.internal_name), "INFO", "_ready")
