extends Menu

func _ready():
	super()
	self.internal_name = "credits"
func _on_return_button_down() -> void :
	$Uipress.play()
	CC3D.load_menu("trophyroom")
func _on_return_button_up() -> void :
	$Uirelease.play()
func _on_return_mouse_entered() -> void :
	$Uihover.play()
