extends Node3D

func _log(msg: String, type: String, function_name: String):
	CC3D.log(msg, type, self, function_name)

func _ready() -> void:
	var __log = func(msg, type := "INFO"):
		_log(msg, type, "_ready")

	Global.root = self
	CC3D.set_render_resolution(128, 128)
	print("game start!")
	CC3D.load_menu("main_menu") 
