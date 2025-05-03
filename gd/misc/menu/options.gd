extends Node

func _log(msg: String, type: String = "INFO") -> void:
	CC3D.log(msg, type, self)

func _ready():
	$Name.text = Global.playername
	var data = ResourceLoader.load(Global.save_location) as SaveData
	var muVol = data.musicvol
	var maVol = data.mastervol
	var fulSc = data.fullscreen
	var lighting = data.lighting
	var phyCull = data.physics_cull
	var phyCullAmt = data.physics_cull_amt
	var phyCullSph = data.enable_physics_sphere
	var debugRendering = data.debug_rendering
	var enableSheepTargetting = data.enable_sheep_targetting
	$Master.value = maVol
	$Music.value = muVol
	$Fullscreen.button_pressed = fulSc
	$Lighting.button_pressed = lighting
	$PhysicsCulling.button_pressed = phyCull
	$PhysicsCullingSlider.value = phyCullAmt
	$PhysicsSphere.button_pressed = phyCullSph
	$DebugRendering.button_pressed = debugRendering
	$SheepTargetting.button_pressed = enableSheepTargetting

func _on_master_value_changed(value: float) -> void :
	AudioServer.set_bus_volume_db(0, value)
func _on_music_value_changed(value: float) -> void :
	AudioServer.set_bus_volume_db(1, value)
func _on_physics_value_changed(value: float) -> void :
	Global.physics_cull_amt = value
	
	# move shit to handle
	#$PhysicsCullingSlider.position
	$PhysicsCullingSlider/count.text = "(" + str(int(value)) + ")"
	

func _on_fullscreen_toggled(toggled_on: bool) -> void :
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if toggled_on == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_name_text_changed(new_text: String) -> void :
	Global.playername = new_text

func _on_physics_culling_toggled(toggled_on: bool) -> void :
	Global.enable_physics_culling = toggled_on
	
func _on_lighting_toggled(toggled_on: bool) -> void :
	Global.enable_enhanced_lighting = toggled_on

func _on_physics_sphere_toggled(toggled_on: bool) -> void :
	Global.enable_physics_sphere = toggled_on

func _on_sheep_targetting_toggled(toggled_on: bool) -> void :
	Global.enable_sheep_targetting = toggled_on

func _on_save_pressed() -> void :
	$Uirelease.play()
	var data = SaveData.new()
	data.mastervol = $Master.value
	data.musicvol = $Music.value
	data.fullscreen = $Fullscreen.button_pressed
	data.savename = Global.playername
	data.saveunlockedlevels = Global.unlockedlevels
	data.beatenlevels = Global.beatenlevels
	data.lighting = Global.enable_enhanced_lighting
	data.physics_cull = Global.enable_physics_culling
	data.physics_cull_amt = Global.physics_cull_amt
	data.enable_physics_sphere = Global.enable_physics_sphere
	data.debug_rendering = Global.debug_rendering
	data.enable_sheep_targetting = Global.enable_sheep_targetting
	ResourceSaver.save(data, Global.save_location)
	_log("Saved")
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func _on_save_2_pressed() -> void :
	$Uirelease.play()
	var data = SaveData.new()
	Global.unlockedlevels = 1
	data.beatenlevels = 0
	Global.beatenlevels = 0
	data.saveunlockedlevels = Global.unlockedlevels
	$Baa.pitch_scale = randf_range(0.7, 1.3)
	$Baa.play()
	ResourceSaver.save(data, Global.save_location)

	_log("Progress Erased.")


func _on_master_drag_ended(value_changed: bool) -> void :
	$Baa.pitch_scale = randf_range(0.7, 1.3)
	$Baa.play()

func _on_physics_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.


func _on_save_button_down() -> void :
	$Uipress.play()
func _on_save_2_button_down() -> void :
	$Uipress.play()
func _on_save_2_mouse_entered() -> void :
	$Uihover.play()
func _on_save_mouse_entered() -> void :
	$Uihover.play()


func _on_debug_rendering_toggled(toggled_on: bool) -> void:
	Global.debug_rendering = toggled_on
