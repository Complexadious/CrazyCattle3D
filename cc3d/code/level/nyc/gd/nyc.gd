extends Node3D

@export var internal_name = "nyc"
var env : Environment
var fov : float


func _ready():
	Global.currentlevel = "new york city"
	Global.currentlevelfenceradius = 60
	Global.currentlevelmaxsheep = 75
	Global.onLevelLoad($".")
	env = $WorldEnvironment.environment
		
func _process(delta: float) -> void:
	fov = $Player/VehicleBody3D/Camera3D.fov
	env.sky_custom_fov = fov


func _on_bg_audio_finished() -> void:
	$World1.play()
