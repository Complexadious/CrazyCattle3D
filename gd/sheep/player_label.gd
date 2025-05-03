extends Label3D
var localnum = 0
var prefixed_name = ""
func _ready():
	text = str(Global.playername)
	localnum = Global.playername
	prefixed_name = Global.playername
	$Label3D2.text = str(localnum)
