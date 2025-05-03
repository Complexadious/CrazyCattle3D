extends Node3D

var kills = 0

func _on_refresh_physics_culling_timeout():
	if Global.enable_physics_culling:
		$VehicleBody3D.refreshPhysicsCulling()
