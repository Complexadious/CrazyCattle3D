extends Node
class_name multiplayerhandler

@export var bind_ip := "localhost"
@export var bind_port := 25565

var clients : Dictionary
@export var player_scene : PackedScene = load("res://scenes/sheep/playernode.tscn")
var peer := ENetMultiplayerPeer.new()

func _init() -> void:
	print("Multiplayer constructor ran")

func _ready():
	Global.register_multiplayer_ref(self)

	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	# Add yourself
	_add_player(multiplayer.get_unique_id())

func _on_peer_connected(id):
	print("Peer connected: ", id)
	_add_player(id)

func _on_peer_disconnected(id):
	var node = get_node_or_null(str(id))
	if node:
		node.queue_free()

func host(port):
	print("Multiplayer host ran: " + str(port))
	peer.create_server(25565, 1)
	_add_player(1)
		
func join(ip : String, port: int):
	print("Multiplayer join ran: " + str(port))
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	
func _add_player(id):
	var player = player_scene.instantiate()
	player.set("peer_id", id)  # ensures @export var is updated before _enter_tree
	player.name = str(id)
	call_deferred("add_child", player)
