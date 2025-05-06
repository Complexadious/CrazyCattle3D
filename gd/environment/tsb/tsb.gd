extends Node3D

@export var internal_name = "oblock"
var env : Environment
var fov : float

func _ready():
	Global.currentlevel = "oblock"
	Global.currentlevelfenceradius = 60
	Global.currentlevelmaxsheep = 60
	Global.onLevelLoad($".")
	env = $WorldEnvironment.environment
		
func _process(delta: float) -> void:
	fov = $Player/VehicleBody3D/Camera3D.fov
	env.sky_custom_fov = fov
