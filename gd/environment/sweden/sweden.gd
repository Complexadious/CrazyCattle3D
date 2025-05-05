extends Node3D

@export var internal_name = "sweden"
var env : Environment
var fov : float

func _ready():
	Global.currentlevel = "sweden"
	Global.currentlevelfenceradius = 90
	Global.currentlevelmaxsheep = 320
	Global.onLevelLoad($".")
	env = $WorldEnvironment.environment
		
func _process(delta: float) -> void:
	fov = $Player/VehicleBody3D/Camera3D.fov
	env.sky_custom_fov = fov
