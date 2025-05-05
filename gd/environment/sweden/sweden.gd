extends Node3D

var env : Environment
var fov : int

func _ready():
	Global.currentlevel = "sweden"
	Global.currentlevelfenceradius = 90
	Global.currentlevelmaxsheep = 320
	Global.onLevelLoad($".")
	
	env = $WorldEnvironment.environment
	fov = $Player/VehicleBody3D/Camera3D.fov
		
func _physics_process(delta: float) -> void:
	Global.calculateLevelProcessingDist()
	env.sky_custom_fov = fov
