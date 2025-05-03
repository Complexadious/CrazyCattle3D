extends Node2D

func updateUnlocks():
	if Global.unlockedlevels >= 1:
		$Worldmap / ire.disabled = false
		if Global.unlockedlevels >= 2:
			$Worldmap / egy.disabled = false
			if Global.unlockedlevels >= 3:
				$Worldmap / swe.disabled = false
	if Global.enable_nyc:
		$Worldmap / nyc.disabled = false

func updateUIticks():
	if Global.beatenlevels >= 1:
		$Worldmap / Yes.show()
		if Global.beatenlevels >= 2:
			$Worldmap / Yes2.show()
			if Global.beatenlevels >= 3:
					$Worldmap / Yes3.show()

func _on_swe_pressed() -> void :
	$Worldmap / Uirelease.play()
	get_tree().change_scene_to_file("res://scenes/environment/sweden.tscn")

func _on_ire_pressed() -> void :
	$Worldmap / Uirelease.play()
	get_tree().change_scene_to_file("res://scenes/environment/environment2.tscn")

func _on_nyc_pressed() -> void :
	$Worldmap / Uirelease.play()
	if Global.enable_nyc:
		get_tree().change_scene_to_file("res://scenes/environment/nyc.tscn")

func _on_egy_pressed() -> void :
	$Worldmap / Uirelease.play()
	get_tree().change_scene_to_file("res://scenes/environment/egypt.tscn")

func _on_return_pressed() -> void :
	$Worldmap / Uirelease.play()
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	updateUnlocks()
	updateUIticks()
	if !Global.enable_nyc:
		CC3D.log("NYC directory at '"+str(Global.nyc_resources_path)+"' doesn't exist or 'Global.enable_nyc' is 'false', (NYC is disabled!)", "WARNING", self)
func _on_return_2_pressed() -> void :
	$Worldmap / Uirelease.play()
	get_tree().change_scene_to_file("res://scenes/menu/trophyroom.tscn")


func _on_swe_button_down() -> void :
	$Worldmap / Uipress.play()

func _on_ire_button_down() -> void :
	$Worldmap / Uipress.play()

func _on_nyc_button_down() -> void :
	$Worldmap / Uipress.play()

func _on_egy_button_down() -> void :
	$Worldmap / Uipress.play()


func _on_return_button_down() -> void :
	$Worldmap / Uipress.play()


func _on_return_2_button_down() -> void :
	$Worldmap / Uipress.play()



func _on_swe_mouse_entered() -> void :
	if $Worldmap / swe.disabled == false:
		$Worldmap / Uihover.play()


func _on_ire_mouse_entered() -> void :
	if $Worldmap / ire.disabled == false:
		$Worldmap / Uihover.play()

func _on_nyc_mouse_entered() -> void :
	if $Worldmap / ire.disabled == false:
		$Worldmap / Uihover.play()


func _on_egy_mouse_entered() -> void :
	if $Worldmap / egy.disabled == false:
		$Worldmap / Uihover.play()


func _on_return_mouse_entered() -> void :
	$Worldmap / Uihover.play()

func _on_return_2_mouse_entered() -> void :
	$Worldmap / Uihover.play()
