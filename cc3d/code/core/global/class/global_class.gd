extends Node
var global_dead = false
var global_sheep = 0

signal sheepDie

var sheepnum = 0

var save_location = "user://savefile.tres"

var physics_cull_amt = 1.0

var eliminated = ""

var playername = "Nardo Polo"

var currentlevel = ""

var currentlevelfenceradius = 260

var currentlevelmaxsheep = 60

var currentlevelminprocessingdist = 60 # set in options.gd & enable_physics_culling

var currentlevelprocessingdist = currentlevelminprocessingdist

var enable_physics_culling = true

var enable_enhanced_lighting = true

var enable_physics_sphere = false

var unlockedlevels = 0

var beatenlevels = 0

var airborne = false

var fly = false

var rot_momentum_forward = 0

var lasttouchedsheep_timeout = 120

var node_alias_substitutions = {
	"StaticBody3D": "fence",
	"VehicleBody3D": "sheep",
	"CSGBox3D": "ground"
}

var QuickTextScript = null

func set_quick_text_ref(ref):
	QuickTextScript = ref

var PlayerRef = null

func register_player_ref(ref):
	PlayerRef = ref
	
var WorldRef = null

func register_world_ref(ref):
	print("Registered world ref: '" + str(ref) + "'")
	WorldRef = ref
	
var MultiplayerRef = null
	
func register_multiplayer_ref(ref):
	print("Registered multiplayer ref: '" + str(ref) + "'")
	WorldRef = ref
	MultiplayerRef = ref

var set_fov = 110

var game_tick = 0

func calculateLevelProcessingDist():
	pass
#	Global.currentlevelprocessingdist = Global.physics_cull_amt * (Global.currentlevelfenceradius - (Global.currentlevelfenceradius / Global.currentlevelmaxsheep) * Global.global_sheep) + Global.currentlevelminprocessingdist

func onLevelLoad(ref):
	print("Level Loaded: " + str(Global.currentlevel))
	register_world_ref(ref)
	
	# manage better lighting
	if !Global.enable_enhanced_lighting:
		var light = ref.get_node("DirectionalLight3D")
		var we = ref.get_node("WorldEnvironment")
		var env = we.environment if (we != null) else null
		if (light != null):
			light.shadow_enabled = false
			light.light_energy = 0.0
			light.sky_mode = DirectionalLight3D.SKY_MODE_SKY_ONLY
		else:
			print("onLevelLoad: Error managing enhanced lighting, 'DirectionalLight3D' not found!")
		if (env != null):
			env.sdfgi_enabled = false
			env.tonemap_exposure = 1
		else:
			print("onLevelLoad: Error managing enhanced lighting, 'WorldEnvironment.environment' not found!")
	
	var y = Global.WorldRef.get_node("Player").global_position.y
	var fpos = Global.WorldRef.get_node("NavigationRegion3D").get_node("fencircular").global_position
	var center = Vector3(fpos.x, y, fpos.z)
	CC3D.spawn_sheep_in_circle(Global.currentlevelmaxsheep, center, Global.currentlevelfenceradius)
	
var debug_rendering = false

var sheep_target_position : Vector3 = Vector3.ZERO

var enable_sheep_targetting : bool = false

var enable_nyc : bool = true

var enable_china : bool = false

var spawn_sheep_radius = 170

var sheep_spawn_count = 60

var sheep_spawn_center = Vector3.ZERO

var root = null

var cc3d_game_version = str(ProjectSettings.get_setting("application/config/version")) + " (Dev/"+str(OS.get_name())+")"

#var multi = MultiplayerHandler
