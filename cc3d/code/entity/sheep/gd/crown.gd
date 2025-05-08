extends Node3D

var p = null
@export var crown_count = 0
var crown_height_offset = 0.3
var crowns = null
var mount = null
var base_mesh = null

func _log(msg: String, type: String = "INFO") -> void:
	CC3D.log(msg, type, self)

func _ready():
	crowns = $crowns
	p = get_parent()
	mount = p.get_node("crown_mount")
	base_mesh = $MeshInstance3D.mesh  # Grab only the MESH from the scene

#	_log("crown created! Parent: '" + str(p) + "', mount: '" + str(mount) + "'")
	
	# Optional: remove base mesh visual
	$MeshInstance3D.visible = false

func _physics_process(delta: float) -> void:
	var cc = mount.get_child_count()
	if (cc == crown_count):
		return
	elif (cc < crown_count):
		var new_crown = MeshInstance3D.new()
		new_crown.mesh = base_mesh
		new_crown.scale = Vector3(0.25, 0.25, 0.25)
		new_crown.rotation_degrees = Vector3(-90, (randi_range(0, 18) * 20), 0)
		if mount:
			mount.add_child(new_crown)
		else:
			p.add_child(new_crown)
		new_crown.name = "crown_" + str(mount.get_child_count())
		new_crown.position = Vector3(0, crown_height_offset * cc, 0)
