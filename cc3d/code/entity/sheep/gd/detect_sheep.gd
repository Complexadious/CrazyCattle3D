extends ShapeCast3D

var lasttouchedsheep = null
var lasttouchedsheepname = null
var lasttouchedsheep_timeout = Global.lasttouchedsheep_timeout
var lasttouchedsheep_timeout_curr = 0

func _physics_process(delta: float) -> void:
	if !is_colliding():
		lasttouchedsheep_timeout_curr -= 1
		return
	
	var curr_collider = get_collider(0)
	
	if curr_collider is VehicleBody3D:
		var l3d = curr_collider.get_node("sheep").get_node("Label3D")
		var n = (l3d.prefixed_name) if (l3d != null) else null
		lasttouchedsheep = curr_collider
		lasttouchedsheepname = n
		lasttouchedsheep_timeout_curr = lasttouchedsheep_timeout
		
	if (lasttouchedsheep_timeout_curr > 0):
		lasttouchedsheep_timeout_curr -= 1
	else:
		lasttouchedsheep = null
		lasttouchedsheepname = null
	
	if self.has_node("RichTextLabel"):
		$RichTextLabel.text = "Touched: " + str(lasttouchedsheepname)
