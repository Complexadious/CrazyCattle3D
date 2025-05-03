extends Node2D

func _log(msg: String, type: String = "INFO") -> void:
	CC3D.log(msg, type, self)

func updateTrophies():
	if Global.beatenlevels >= 1:
		$one.show()
		if Global.beatenlevels >= 2:
			$two.show()
			if Global.beatenlevels >= 3:
				$three.show()
				$return2.show()

func _ready():
	$Panel / AnimationPlayer.play("fadein")
	updateTrophies()
	_log(Global.beatenlevels)
func _on_return_pressed() -> void :
	$Uirelease.play()
	get_tree().change_scene_to_file("res://scenes/menu/worldmap.tscn")
func _on_return_button_down() -> void :
	$Uipress.play()
func _on_return_mouse_entered() -> void :
	$Uihover.play()


func _on_return_2_pressed() -> void :
	get_tree().change_scene_to_file("res://scenes/menu/credits.tscn")
