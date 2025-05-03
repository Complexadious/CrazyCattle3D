extends Node3D
func _ready():
	Global.currentlevel = "new york city"
	Global.currentlevelfenceradius = 260
	Global.currentlevelmaxsheep = 60
	Global.currentlevelminprocessingdist = 60 if Global.enable_physics_culling else 512
	Global.currentlevelprocessingdist = Global.currentlevelminprocessingdist		
	Global.onLevelLoad($".")
	
func _physics_process(delta: float) -> void:
	Global.game_tick += 1
	Global.calculateLevelProcessingDist()
	
	#fov fix
	var env = $WorldEnvironment.environment
	var fov = $Player/VehicleBody3D/Camera3D.fov
	env.sky_custom_fov = fov
