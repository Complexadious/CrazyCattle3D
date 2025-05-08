extends Node3D

var navigation
@export var navigation_region: NavigationRegion3D
@export var max_speed = 6.0
@export var acceleration = 15.0
@export var friction = 8.0
@export var stop_distance = 0.3

var path = []
var path_index = 0
var velocity = Vector3.ZERO

var target : Node3D = null
var target_position := Vector3.ZERO  # ← THIS is where you define the player location (or any goal)
var wf = null

var initalized := false

func _log(msg: String, type: String = "INFO") -> void:
	CC3D.log(msg, type, self)

func _ready() -> void:
	_log("nextbot initalizing")

	navigation = get_world_3d().get_navigation_map()

	wf = Global.WorldRef
	if (wf != null):
		target = wf.find_child("Player")
		navigation = wf.find_child("NavigationRegion3D")
		initalized = true
		_log("nextbot initalized!")
	else:
		_log("nextbot warning, world ref is null!")
	
	if (target != null):
		target_position = target.get("global_position")
		_log("nextbot got target pos!")
	else:
		_log("nextbot warning, target is null or doesn't have global_position")
	
func update_target_pos() -> void:
	if !initalized:
		_log("reattempting initalization")
		_ready()
		pass
	
	target_position = target.get("global_position") if (target is Node3D) else global_position
	if (target_position == global_position):
		_log("nextbot warning, target_position is my position (skipping move_to call)")
		pass
	move_to(target_position)

func move_to(target: Vector3) -> void:
	_log("nextbot move to")
	path = NavigationServer3D.map_get_path(navigation, global_position, target, true)
	path_index = 0

func _physics_process(delta) -> void:
	if path.is_empty():
		# Slow down if no path
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		_log("nextbot path is empty")
	else:
		_log("nextbot path isnt empty")
		var target_point = path[path_index]
		var direction = (target_point - global_transform.origin).normalized()

		# Accelerate toward the direction
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)

		# Check if close enough to the current point
		if global_transform.origin.distance_to(target_point) < stop_distance:
			path_index += 1
			if path_index >= path.size():
				path.clear()  # finished moving

	# Actually move
	global_translate(velocity * delta)

	# (Optional) Look toward movement
	if velocity.length() > 0.1:
		look_at(global_transform.origin + velocity, Vector3.UP)
