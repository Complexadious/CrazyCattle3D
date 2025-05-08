extends Menu

func updateTrophies():
	if Global.beatenlevels >= 1:
		$one.show()
		if Global.beatenlevels >= 2:
			$two.show()
			if Global.beatenlevels >= 3:
				$three.show()
				$return2.show()

func _ready():
	super()
	self.internal_name = "trophyroom"
	
	$Panel / AnimationPlayer.play("fadein")
	updateTrophies()
	_log(Global.beatenlevels, "INFO", "_ready")
func _on_return_pressed() -> void :
	$Uirelease.play()
	CC3D.load_menu("worldmap")
func _on_return_button_down() -> void :
	$Uipress.play()
func _on_return_mouse_entered() -> void :
	$Uihover.play()


func _on_return_2_pressed() -> void :
	CC3D.load_menu("credits")
