extends Node
class_name CrazyCattle3D

var _cached_timestamp = "GAME_START"
var _type_colors = {
	"INFO": "#b5b5b5",
	"WARN": "#d1d100",
	"WARNING": "#d1d100",
	"ERROR": "#ff0000"
}
var _fallback_type_color = "gray"

func _process(_delta):
	_cached_timestamp = get_timestamp()

static func get_timestamp() -> String:
	var ts = Time.get_datetime_dict_from_system()
	var h = str(ts["hour"]).pad_zeros(2)
	var m = str(ts["minute"]).pad_zeros(2)
	var s = str(ts["second"]).pad_zeros(2)
	return "%s:%s:%s" % [h, m, s]
	
func log(msg: String = "UnsetMessage", type: String = "UnsetType", caller: Node = null, function_name: String = ""):
	var caller_name = caller.name if caller != null else "[color=red]UnknownName"
	var caller_str = str(caller.get_class()) if caller != null else "[color=red]UnknownClass"
	var _tc = _type_colors[type] if _type_colors.has(type) else _fallback_type_color
	if (function_name != ""):
		print_rich("[color=#7d7d7d]["+_cached_timestamp+"] [color=gray]["+caller_name+"[color=#7d7d7d]<[color=#7d7d7d]"+caller_str+"[color=#7d7d7d]>[color=#b5b5b5]/FUNC/"+function_name+"[color=gray]] [color="+_tc+"]["+type+"]: [color=white]"+msg)
	else:
		print_rich("[color=#7d7d7d]["+_cached_timestamp+"] [color=gray]["+caller_name+"[color=#7d7d7d]<[color=#7d7d7d]"+caller_str+"[color=#7d7d7d]>[color=gray]] [color="+_tc+"]["+type+"]: [color=white]"+msg)
	# [12H:49M:0S:625] [obj_sys/FUNC/web_asset_data_init] [INFO]:

func _log(msg: String, type: String, function_name: String):
	CC3D.log(msg, type, self, function_name)

func spawn_sheep_at(pos: Vector3, rot: Vector3, name_or_num = Global.sheepnum, prefixed_name = name_or_num) -> Node3D:
	var __log = func(msg, type := "INFO"):
		_log(msg, type, "spawn_sheep_at")
	__log.call("spawning sheep at " + str(pos), "INFO")
	var sheep = load("res://scenes/sheep/characternode.tscn").instantiate()
	var loc = Global.WorldRef.get_node_or_null("Sheep") if Global.WorldRef != null else null
	if (loc != null):
		loc.add_child(sheep)
		var vehicle = sheep.get_node("VehicleBody3D")
		vehicle.global_position = pos
		vehicle.global_rotation = rot
		if (str(name_or_num) != str(Global.sheepnum)):
			vehicle.get_node("sheep").get_node("Label3D")._apply_name(name_or_num, prefixed_name)
		__log.call("Created sheep '"+str(name_or_num)+"'!")
		return sheep
	else:
		__log.call("Issue creating sheep, 'Sheep' node is null in 'Global.WorldRef'", "ERROR")
		return null
	
func spawn_sheep_in_circle(max_sheep: int, center: Vector3, radius: float):
	var __log = func(msg, type := "INFO"):
		_log(msg, type, "spawn_sheep_in_circle")
	__log.call("spawning sheep in a circle of radius "+str(radius)+" centered at "+str(center), "INFO")
	for num in range(max_sheep):
		var angle = randf_range(0, TAU)
		var dist = sqrt(randf()) * radius
		var x = center.x + dist * cos(angle)
		var z = center.z + dist * sin(angle)
		var pos = Vector3(x, center.y, z)
		var rot = Vector3(0, randf_range(0, 6.283), 0)
		var vehicle = spawn_sheep_at(pos, rot).get_node("VehicleBody3D")
		var detect_dead = vehicle.get_node("detect_dead")
		while (detect_dead.is_colliding()):
			angle = randf_range(0, TAU)
			dist = sqrt(randf()) * radius
			vehicle.global_position = center + Vector3(dist * cos(angle), 0, dist * sin(angle))
			__log.call("sheep had to be moved since colliding w sum")
	
