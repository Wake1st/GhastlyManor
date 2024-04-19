extends MultiplayerSpawner

@export var playerScene:PackedScene

var players:Dictionary = {}


func _ready():
	spawn_function = spawnPlayer
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(removePlayer)


func spawnPlayer(data):
	var p = playerScene.instantiate()
	p.set_multiplayer_authority(data)
	players[data] = p
	return p


func removePlayer(data):
	players[data].queue_free()
	players.erase(data)
