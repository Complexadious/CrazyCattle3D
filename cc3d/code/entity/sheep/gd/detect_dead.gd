extends ShapeCast3D

var lasttouchedobject = null

func _physics_process(delta: float) -> void:
	if !is_colliding():
		return
	
	var curr_collider = get_collider(0)
	var collider_alias = curr_collider
	
	if (curr_collider != null):
		var n = curr_collider.get("name")
		var r = Global.node_alias_substitutions.get(n)
		if (r != null):
			n = r
		lasttouchedobject = n
