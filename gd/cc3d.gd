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

# Publicly accessible
@export var path = {}
@export var level : Node3D = null
@export var level_internal_name : String = ""
@export var menu : Node2D = null
@export var menu_internal_name : String = ""

func _process(_delta):
	_cached_timestamp = get_timestamp()

static func get_timestamp() -> String:
	var ts = Time.get_datetime_dict_from_system()
	var h = str(ts["hour"]).pad_zeros(2)
	var m = str(ts["minute"]).pad_zeros(2)
	var s = str(ts["second"]).pad_zeros(2)
	return "%s:%s:%s" % [h, m, s]
	
func log(msg = "UnsetMessage", type: String = "UnsetType", caller: Node = null, function_name: String = ""):
	var caller_name = caller.name if caller != null else "[color=red]UnknownName"
	var caller_str = str(caller.get_class()) if caller != null else "[color=red]UnknownClass"
	var _tc = _type_colors[type] if _type_colors.has(type) else _fallback_type_color
	msg = str(msg)
	if (function_name != ""):
		print_rich("[color=#7d7d7d]["+_cached_timestamp+"] [color=gray]["+caller_name+"[color=#7d7d7d]<[color=#7d7d7d]"+caller_str+"[color=#7d7d7d]>[color=#b5b5b5]/FUNC/"+function_name+"[color=gray]] [color="+_tc+"]["+type+"]: [color=white]"+msg)
	else:
		print_rich("[color=#7d7d7d]["+_cached_timestamp+"] [color=gray]["+caller_name+"[color=#7d7d7d]<[color=#7d7d7d]"+caller_str+"[color=#7d7d7d]>[color=gray]] [color="+_tc+"]["+type+"]: [color=white]"+msg)
	# [12H:49M:0S:625] [obj_sys/FUNC/web_asset_data_init] [INFO]:

func quit() -> void:
	_log("Quitting", "INFO", "quit")
	get_tree().quit()

func _log(msg: String, type: String, function_name: String):
	CC3D.log(msg, type, self, function_name)

func is_a_level_loaded():
	return (self.level != null)
	
func is_a_menu_loaded():
	return (self.menu != null)

func reload_level() -> void:
	var lvl = self.level.internal_name if self.level.internal_name != null else "NO_LEVEL_LOADED"
	_log("Reloading level '"+str(self.level)+"'", "INFO", "reload_level")
	if self.level.internal_name != null:
		load_level(self.level.internal_name)
		
func reload_menu() -> void:
	var lvl = self.menu.internal_name if self.menu.internal_name != null else "NO_MENU_LOADED"
	_log("Reloading menu '"+str(self.menu)+"'", "INFO", "reload_menu")
	if self.menu.internal_name != null:
		load_level(self.menu.internal_name)

func clear_menus() -> void:
	self.menu = null
	var menus = Global.root.get_node("Menu").get_children()
	for menu in menus:
		menu.queue_free()
		
func clear_levels() -> void:
	self.level = null
	var levels = Global.root.get_node("Level").get_children()
	for level in levels:
		level.queue_free()

func load_level(internal_level_name: String) -> void:
	_log("Loading level '"+internal_level_name+"'", "INFO", "load_level")
	clear_menus()
	clear_levels()
	var path = "res://scenes/environment/"+internal_level_name+"/"+internal_level_name+".tscn"
	if !DirAccess.dir_exists_absolute(path):
		_log("Unable to load non-existent level '"+internal_level_name+"' ("+path+")", "ERROR", "load_level")
		pass
	var l = load(path).instantiate()
	Global.root.get_node("Level").add_child(l)
	l.internal_name = internal_level_name
	self.level = l

func load_menu(internal_menu_name: String, clear_level: bool = true) -> void:
	_log("Loading menu '"+internal_menu_name+"'", "INFO", "load_menu")
	clear_menus()
	if clear_level:
		clear_levels()
	var path = "res://scenes/menu/"+internal_menu_name+".tscn"
	if !DirAccess.dir_exists_absolute(path):
		_log("Unable to load non-existent menu '"+internal_menu_name+"' ("+path+")", "ERROR", "load_level")
		pass
	var m = load(path).instantiate()
	Global.root.get_node("Menu").add_child(m)
	m.internal_name = internal_menu_name
	self.menu = m

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
	
