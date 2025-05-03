extends Label3D
var localnum = 0
var prefixed_name = ""
func _ready():
	_apply_name(Global.sheepnum, "No. " + str(Global.sheepnum))
	Global.sheepnum += 1
	
func _apply_name(num_or_name, _prefixed_name = num_or_name):
	localnum = num_or_name
	prefixed_name = str(_prefixed_name)
	text = str(localnum)
	$Label3D2.text = text
