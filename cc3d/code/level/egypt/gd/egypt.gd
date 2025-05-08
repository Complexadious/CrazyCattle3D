extends Node3D

@export var internal_name = "egypt"
var env : Environment
var fov : float

func _ready():
	Global.currentlevel = "egypt"
	Global.currentlevelfenceradius = 60
	Global.currentlevelmaxsheep = 130
	Global.onLevelLoad($".")
	env = $WorldEnvironment.environment
		
func _process(delta: float) -> void:
	fov = $Player/VehicleBody3D/Camera3D.fov
	env.sky_custom_fov = fov
