extends Menu

func _ready():
	super()
	self.internal_name = "multiplayer"

func _on_back_pressed() -> void :
	$Uirelease.play()
	CC3D.load_menu("main_menu")

func _on_back_button_down() -> void :
	$Uipress.play()
func _on_back_mouse_entered() -> void :
	$Uihover.play()


func _on_debug_rendering_toggled(toggled_on: bool) -> void:
	Global.debug_rendering = toggled_on


func _on_join_pressed() -> void:
	MultiplayerHandler.bind_ip = $HostIP.text
	MultiplayerHandler.bind_port = $HostPort.text
	MultiplayerHandler.join($HostIP.text, int($HostPort.text))
	
func _on_host_pressed() -> void:
	MultiplayerHandler.bind_ip = $HostIP.text
	MultiplayerHandler.bind_port = $HostPort.text
	MultiplayerHandler.host(int($HostPort.text))


func _on_back_button_up() -> void:
	pass # Replace with function body.
