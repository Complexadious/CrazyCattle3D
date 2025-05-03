extends Node

#func _ready():
	#$Name.text = Global.playername
	#var data = ResourceLoader.load(Global.save_location) as SaveData
	#var muVol = data.musicvol
	#var maVol = data.mastervol
	#var fulSc = data.fullscreen
	#var lighting = data.lighting
	#var phyCull = data.physics_cull
	#var phyCullAmt = data.physics_cull_amt
	#var phyCullSph = data.enable_physics_sphere
	#var debugRendering = data.debug_rendering
	#var enableSheepTargetting = data.enable_sheep_targetting
	#$Master.value = maVol
	#$Music.value = muVol
	#$Fullscreen.button_pressed = fulSc
	#$Lighting.button_pressed = lighting
	#$PhysicsCulling.button_pressed = phyCull
	#$PhysicsCullingSlider.value = phyCullAmt
	#$PhysicsSphere.button_pressed = phyCullSph
	#$DebugRendering.button_pressed = debugRendering
	#$SheepTargetting.button_pressed = enableSheepTargetting

func _on_back_pressed() -> void :
	$Uirelease.play()
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

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
