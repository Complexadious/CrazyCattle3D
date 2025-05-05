extends VehicleBody3D

var isdead = false
var iswinstate = false

var rotating = false
var mouse_sensitivity = 0.005
var c = null
var p = null
var flip_camera := false

var cam_inital_x = -44

# ──────────────────────────────────────────────────────────────────────────────
# one-time helpers (put at the top of the script)
# ──────────────────────────────────────────────────────────────────────────────
var _tmp_pairs  : Array[Vector2] = []   # [ distance² , index ]
var _tmp_sheep  : Array          = []   # Node references
var _last_radius: float          = 0.0  # for the debug sphere

@export var peer_id : int

#func _enter_tree() -> void:
#	set_multiplayer_authority(int(peer_id))

func _log(msg: String, type: String = "INFO") -> void:
	CC3D.log(msg, type, self)

func _ready():
	p = get_parent()
	c = $sheep/Crown
	c.visible = false
	Global.set_quick_text_ref($close_call_txt)
	_log("Registered QuickText Ref: " + str(Global.QuickTextScript))
	Global.register_player_ref($".")
	_log("Registered Player Ref: " + str(Global.PlayerRef))
	$sphere.visible = Global.enable_physics_sphere
	cam_inital_x = $Camera3D.global_rotation.x
	
func bleat():
	$Bleat.pitch_scale = randf_range(0.7, 1.3)
	$Bleat.play()

func freeCam():
	$Node / Camera3D3 / AudioListener3D.make_current()
	$Node / Camera3D3.make_current()

func unlockshit():
	if Global.currentlevel == "ireland":
		if Global.unlockedlevels == 1:
			Global.beatenlevels = 1
			Global.unlockedlevels = 2
	elif Global.currentlevel == "egypt":
		if Global.unlockedlevels == 2:
			Global.beatenlevels = 2
			Global.unlockedlevels = 3
	elif Global.currentlevel == "sweden":
		if Global.unlockedlevels == 3:
			Global.beatenlevels = 3
			Global.unlockedlevels = 4

func win():
	$Node / Camera3D3 / freecamlisten / Crowd.play()
	$detect_dead / RichTextLabel5.show()
	freeCam()
	unlockshit()
	saveprogress()
	iswinstate = true
	_log("You win!")

func saveprogress():
	var data = SaveData.new()
	data.saveunlockedlevels = Global.unlockedlevels
	data.beatenlevels = Global.beatenlevels
	data.savename = Global.playername
	data.mastervol = AudioServer.get_bus_volume_db(0)
	data.musicvol = AudioServer.get_bus_volume_db(1)
	if DisplayServer.window_get_mode() == (DisplayServer.WINDOW_MODE_FULLSCREEN):
		data.fullscreen = true
	else:
		data.fullscreen = false
	_log("Saved")
	ResourceSaver.save(data, Global.save_location)

func _input(event):
	if event.is_action_pressed("horn"):
		bleat()
		if isdead == true and iswinstate == false:
				Global.global_sheep = 0
				Global.sheepnum = 0
				Global.eliminated = ""
				CC3D.reload_level()
		elif iswinstate == true:
			CC3D.load_menu("worldmap")
	if event.is_action_released("horn"):
		$Bleat.stop()
	if event.is_action_pressed("debug_win"):
		win()
	if event.is_action_pressed("fly"):
		Global.fly = !Global.fly
		$detect_ground / RichTextLabel.visible = Global.fly
		$detect_ground / RichTextLabel.text = "Flying"
	if event.is_action_pressed("test"):
		var targets = Global.WorldRef.get_node("Sheep").get_children()
		for sheep in targets:
			sheep.queue_free()
	if event.is_action_pressed("look_back"):
		if (flip_camera == false): # just changed
			$Camera3D.rotate_y(deg_to_rad(180))
		flip_camera = true
		CC3D.spawn_sheep_at($Camera3D.global_position, global_rotation, "TEST")
	if event.is_action_released("look_back"):
		if (flip_camera == true): # just changed
			$Camera3D.rotate_y(deg_to_rad(180))
		flip_camera = false
	if event.is_action_pressed("host"):
		MultiplayerHandler.host(25565)
	if event.is_action_pressed("join"):
		MultiplayerHandler.join("localhost", 25565)
	
	# handle flight
	if event is InputEventMouseButton and Global.fly:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			rotating = event.pressed

	if rotating and event is InputEventMouseMotion:
		$".".rotate_object_local(Vector3(0,1,0), -event.relative.x * mouse_sensitivity)
		$".".rotate_object_local(Vector3(1,0,0), event.relative.y * mouse_sensitivity)
		#$".".rotate_y(-event.relative.x * mouse_sensitivity)
#		$".".rotate_x(event.relative.y * mouse_sensitivity)

	var flyspeed = 1
	if Global.fly:
		$".".freeze = true
		if event.is_action("forward"):
			var d = $".".global_transform.basis.z
			$".".global_position += d * flyspeed
		if event.is_action("back"):
			var d = -$".".global_transform.basis.z
			$".".global_position += d * flyspeed
		if event.is_action("left"):
			var d = -$".".global_transform.basis.x
			$".".global_position += d * flyspeed
		if event.is_action("right"):
			var d = $".".global_transform.basis.x
			$".".global_position += d * flyspeed
	else:
		$".".freeze = false


var doamovespeed = 100
var won = false
var close_call_cooldown = 120
var close_call_cooldown_curr = 0

func is_airborne():
	Global.airborne = !$detect_ground.is_colliding()
	return Global.airborne

func z_chk(deg):
	return (abs(rad_to_deg(global_rotation.z)) > deg)
func x_chk(deg):
	return (abs(rad_to_deg(global_rotation.z)) > deg)

func refreshPhysicsCulling() -> void:
	# 1. fast early-out ───────────────────────────────────────────────────────
	var world = Global.WorldRef
	if world == null:
		push_warning("Physics-cull: Global.WorldRef is null!")
		return

	var sheep_parent = world.get_node_or_null("Sheep")       # ▸ no ?.
	if sheep_parent == null:
		push_warning("Physics-cull: no Sheep node!")
		return

	_tmp_sheep = sheep_parent.get_children()
	_tmp_pairs.resize(_tmp_sheep.size())

	var player_pos := global_transform.origin

	for i in _tmp_sheep.size():
		var vehicle = _tmp_sheep[i].get_node("VehicleBody3D")
		var dist_sq := player_pos.distance_squared_to(vehicle.global_transform.origin)
		_tmp_pairs[i] = Vector2(dist_sq, i)    # x = distance² , y = index

	_tmp_pairs.sort_custom(func (a : Vector2, b : Vector2) -> bool: return a.x < b.x)

	var radius_sq_limit : float = 0.0
	var limit           : int   = Global.physics_cull_amt
	var last := false
	var last_pos_dist := 2.0

	for idx in _tmp_pairs.size():
		var pair      := _tmp_pairs[idx]
		var sheep     = _tmp_sheep[pair.y]
		var vehicle   = sheep.get_node("VehicleBody3D")
		var is_sleep  := idx >= limit

		# toggle only when state really changes
		if vehicle.sleeping != is_sleep:
			vehicle.sleeping = is_sleep
			vehicle.freeze   = is_sleep          # ▸ Godot-4 hard lock
			#vehicle.set_physics_process(!is_sleep)
		if (!last) && (is_sleep):
			last = true
			last_pos_dist = player_pos.distance_to(vehicle.global_position)
		vehicle.visible = !is_sleep
		vehicle.set_physics_process(!is_sleep)

		# debug colour (creates a material only when debug is ON)
		if Global.debug_rendering:
			var cube = vehicle.get_node_or_null("sheep/Cube")
			if cube:
				var mat  := StandardMaterial3D.new()
				mat.albedo_color = Color(0.5, 0.5, 1.0) if is_sleep else Color(1.0, 0.0, 0.0) 
				cube.material_override = mat

		# distance label for debug
		if Global.debug_rendering:
			var lbl = sheep.get_node_or_null("sheep/DistLabel")
			if lbl:
				lbl.visible = true
				lbl.text    = str(snapped(sqrt(pair.x), 0.01))

	# 5. move visual sphere once  ────────────────────────────────────────────
#	if last_pos_dist != _last_radius and last_pos_dist > 0:
#		_last_radius = last_pos_dist
	$sphere.scale = Vector3(last_pos_dist * 2, last_pos_dist * 2, last_pos_dist * 2)       # sphere mesh has radius = 1 m

#func _process(delta):
#	if !isdead:
#		$Camera3D.global_rotation.z = $sheep.global_rotation.z
#		$Camera3D.global_rotation.x = $sheep.global_rotation.x + cam_inital_x

func _physics_process(delta):
	if not is_multiplayer_authority():
		return  # Only process input if this player is the owner

	if Global.enable_sheep_targetting:
		Global.sheep_target_position = global_position
	
	var speed = linear_velocity.length()
	$Camera3D.fov = (Global.set_fov + speed)
	var collider = $detect_dead.get_collider(0) if $detect_dead.is_colliding() else null
	var dead = $detect_dead.is_colliding() && true if ((collider != null) && !(collider.is_in_group("safe_collidable")) && !(collider is VehicleBody3D)) else false && !Global.fly
	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * delta)
	engine_force = 0 if Global.fly else Input.get_axis("back", "forward") * doamovespeed
	
	# rotation in air
	var rot_force = 1
	var max_rot_momentum = 100
	var rot_momentum_slow_rate = 1
	
	if is_airborne():
		var fwl = (abs(Global.rot_momentum_forward) < max_rot_momentum)
		if Input.is_action_pressed("forward") && fwl:
			Global.rot_momentum_forward += rot_force
		if Input.is_action_pressed("back") && fwl:
			Global.rot_momentum_forward -= rot_force
		
	if (Global.rot_momentum_forward > 0):
		Global.rot_momentum_forward -= rot_momentum_slow_rate
	if (Global.rot_momentum_forward < 0):
		Global.rot_momentum_forward += rot_momentum_slow_rate
	if (abs(Global.rot_momentum_forward) <= rot_force):
		Global.rot_momentum_forward = 0
		
	rotate_object_local(Vector3(0,1,0), Global.rot_momentum_forward)
	
	# trigger close call
	if (close_call_cooldown_curr <= 0) && (z_chk(27) || x_chk(36)) && !is_airborne():
		close_call_cooldown_curr = close_call_cooldown
		$close_call_txt.trigger(QuickScreenTextType.REALLY_CLOSE_CALL, 45)
		$close_call_txt.pause()
	if (close_call_cooldown_curr <= 0) && (z_chk(23) || x_chk(32)) && !is_airborne():
		close_call_cooldown_curr = close_call_cooldown
		$close_call_txt.trigger(QuickScreenTextType.CLOSE_CALL, 45)
		$close_call_txt.pause()
	elif (!z_chk(6) || !x_chk(6)) && !is_airborne():
		$close_call_txt.resume()
	else:
		close_call_cooldown_curr-= 1

	# dead
	if isdead == false:
		if dead == true and iswinstate == false:
			_log("DEAD")
			doamovespeed = 0
			var elim_msg = Global.playername + " has been eliminated."
			if ($detect_dead.lasttouchedobject != null):
				elim_msg = Global.playername + " hit the " + str($detect_dead.lasttouchedobject) + "."
			if ($detect_sheep.lasttouchedsheep != null):
				elim_msg = Global.playername + " was killed by No. " + str($detect_sheep.lasttouchedsheep) + "."
			if ($detect_sheep.lasttouchedsheep != null) && ($detect_dead.lasttouchedobject != null):
				elim_msg = Global.playername + " was pushed into the "+str($detect_dead.lasttouchedobject)+" by No. " + str($detect_sheep.lasttouchedsheep) + "."
			Global.eliminated = elim_msg
			_log(elim_msg)
			$detect_dead / RichTextLabel2.show()
			freeCam()
			$sheep.queue_free()
			$CollisionShape3D.queue_free()
			$Node / Camera3D3 / freecamlisten / Explode.play()
			$Node / Camera3D3 / freecamlisten / explosion.play()
			isdead = true
			$close_call_txt.cancel()
	if dead == false and Global.global_sheep == 0:
		if won == false:
			win()
			won = true
			
	if (c != null) && (p.kills > 0):
		c.visible = true
		c.crown_count = p.kills
