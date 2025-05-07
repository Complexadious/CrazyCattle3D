extends Menu

func _ready():
	super()
	self.internal_name = "worldmap"
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	updateUnlocks()
	updateUIticks()
	if !Global.enable_nyc:
		CC3D.log("NYC directory at '"+str(Global.nyc_resources_path)+"' doesn't exist or 'Global.enable_nyc' is 'false', (NYC is disabled!)", "WARNING", self, "_ready")
		

func updateUnlocks():
	if Global.unlockedlevels >= 1:
		$ire.disabled = false
		if Global.unlockedlevels >= 2:
			$egy.disabled = false
			if Global.unlockedlevels >= 3:
				$swe.disabled = false
	if Global.enable_nyc:
		$nyc.disabled = false

func updateUIticks():
	if Global.beatenlevels >= 1:
		$Yes.show()
		if Global.beatenlevels >= 2:
			$Yes2.show()
			if Global.beatenlevels >= 3:
					$Yes3.show()

func _on_swe_pressed() -> void :
	$Uirelease.play()
	CC3D.load_level("sweden")

func _on_ire_pressed() -> void :
	$Uirelease.play()
	CC3D.load_level("environment2")

func _on_nyc_pressed() -> void :
	$Uirelease.play()
	if Global.enable_nyc:
		CC3D.load_level("nyc")
		#get_tree().change_scene_to_file("res://scenes/environment/nyc/nyc.tscn")
		
func _on_china_pressed() -> void :
	$Uirelease.play()
	if Global.enable_nyc:
		CC3D.load_level("china")
		#get_tree().change_scene_to_file("res://scenes/environment/oblock/oblock.tscn")

func _on_egy_pressed() -> void :
	$Uirelease.play()
	CC3D.load_level("egypt")
	#get_tree().change_scene_to_file("res://scenes/environment/egypt/egypt.tscn")

func _on_return_pressed() -> void :
	$Uirelease.play()
	CC3D.load_menu("main_menu")

func _on_return_2_pressed() -> void :
	$Uirelease.play()
	CC3D.load_menu("trophyroom")


func _on_swe_button_down() -> void :
	$Uipress.play()

func _on_ire_button_down() -> void :
	$Uipress.play()

func _on_nyc_button_down() -> void :
	$Uipress.play()

func _on_china_button_down() -> void :
	$Uipress.play()

func _on_egy_button_down() -> void :
	$Uipress.play()


func _on_return_button_down() -> void :
	$Uipress.play()


func _on_return_2_button_down() -> void :
	$Uipress.play()



func _on_swe_mouse_entered() -> void :
	if $swe.disabled == false:
		$Uihover.play()


func _on_ire_mouse_entered() -> void :
	if $ire.disabled == false:
		$Uihover.play()

func _on_nyc_mouse_entered() -> void :
	if $ire.disabled == false:
		$Uihover.play()

func _on_china_mouse_entered() -> void :
	if $ire.disabled == false:
		$Uihover.play()

func _on_egy_mouse_entered() -> void :
	if $egy.disabled == false:
		$Uihover.play()


func _on_return_mouse_entered() -> void :
	$Uihover.play()

func _on_return_2_mouse_entered() -> void :
	$Uihover.play()
