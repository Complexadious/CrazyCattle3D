extends CanvasLayer

func _ready() -> void:
	# Check if running on mobile (native app or mobile browser)
	var is_mobile = OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios")
	var has_touchscreen = DisplayServer.is_touchscreen_available()
	
	if !(is_mobile && has_touchscreen):
		queue_free()
