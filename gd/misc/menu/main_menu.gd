extends Node

func _log(msg: String, type: String = "INFO") -> void:
	CC3D.log(msg, type, self)

func initialise_game():
	if ResourceLoader.exists(Global.save_location) == true:
		_log("Savefile Exists; Skipping Initialisation")
	else:
		var data = SaveData.new()
		data.savename = "Nardo Polo"
		data.saveunlockedlevels = 1
		data.mastervol = 0
		data.musicvol = 0
		data.beatenlevels = 0
		data.lighting = false
		data.physics_cull = true
		data.physics_cull_amt = 60.0
		data.enable_physics_sphere = false
		data.debug_rendering = false
		ResourceSaver.save(data, Global.save_location)
		_log("Savefile not found; Initialising")



func loadData():

	var data = ResourceLoader.load(Global.save_location) as SaveData
	if (data == null):
		_log("WARNING!! Unable to load save at `"+str(Global.save_location)+"`")
		return
	Global.unlockedlevels = data.saveunlockedlevels
	Global.playername = data.savename
	Global.beatenlevels = data.beatenlevels
	Global.enable_enhanced_lighting = data.lighting
	Global.enable_physics_culling = data.physics_cull
	Global.physics_cull_amt = data.physics_cull_amt
	Global.enable_physics_sphere = data.enable_physics_sphere
	Global.debug_rendering = data.debug_rendering
	Global.enable_sheep_targetting = data.enable_sheep_targetting
	AudioServer.set_bus_volume_db(0, data.mastervol)
	AudioServer.set_bus_volume_db(1, data.musicvol)
	if data.fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	_log("Loaded with name " + Global.playername + " and " + str(Global.unlockedlevels) + " unlocked levels")

func _ready():
	randomize()
	initialise_game()
	loadData()

func uiHover():
	$Uihover.play()

func uiPress():
	$Uipress.play()

func uiRelease():
	$Uirelease.play()

func _on_ng_pressed() -> void :
	get_tree().change_scene_to_file("res://scenes/menu/worldmap.tscn")

func _on_opt_pressed() -> void :
	get_tree().change_scene_to_file("res://scenes/menu/options.tscn")
	
func _on_mul_pressed() -> void :
	get_tree().change_scene_to_file("res://scenes/menu/multiplayer.tscn")

func _on_quit_pressed() -> void :
	$quit.disabled = true
	$opt.disabled = true
	$ng.disabled = true
	$Baa.pitch_scale = randf_range(0.7, 1.3)
	$Baa.play()

func _on_ng_mouse_entered() -> void :
	uiHover()
func _on_opt_mouse_entered() -> void :
	uiHover()
func _on_quit_mouse_entered() -> void :
	uiHover()

func _on_ng_button_up() -> void :
	uiRelease()
func _on_ng_button_down() -> void :
	uiPress()

func _on_opt_button_up() -> void :
	uiRelease()
func _on_opt_button_down() -> void :
	uiPress()
	
func _on_mul_button_up() -> void :
	uiRelease()
func _on_mul_button_down() -> void :
	uiPress()
	
func _on_quit_button_down() -> void :
	uiPress()
func _on_quit_button_up() -> void :
	uiRelease()

func _on_baa_finished() -> void :
	get_tree().quit()


func _on_mul_mouse_entered() -> void:
	pass # Replace with function body.
