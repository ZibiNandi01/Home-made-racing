extends Node

const IP_ADDRESS: String =  "172.17.207.25"  #"127.0.0.1" "172.17.207.25" "172.17.255.255"
const PORT: int = 42069

var peer: ENetMultiplayerPeer

func start_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	

func start_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
