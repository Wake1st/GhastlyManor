extends Node

@onready var multiplayer_spawner = $MultiplayerSpawner

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()


func _ready():
	multiplayer_spawner.spawn_function = spawn_level
	peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(on_lobby_match_list)
	open_lobby_list()


func spawn_level(data):
	var a = (load(data) as PackedScene).instantiate()
	return a


func _on_host_pressed():
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	multiplayer_spawner.spawn("res://level.tscn")
	$Host.hide()
	$Refresh.hide()
	$LobbyContainer/Lobbies.hide()


func _on_refresh_pressed():
	for btn in $LobbyContainer/Lobbies.get_children():
		btn.queue_free()


func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	$Host.hide()
	$Refresh.hide()
	$LobbyContainer/Lobbies.hide()


func _on_lobby_created(con,id):
	if con:
		lobby_id = id
		Steam.setLobbyData(lobby_id,"name","%s's Lobby" % Steam.getPersonaName())
		Steam.setLobbyJoinable(lobby_id,true)


func open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()


func on_lobby_match_list(lobbies):
	for lobby in lobbies:
		var lobbyName = Steam.getLobbyData(lobby,"name")
		var memberCount = Steam.getNumLobbyMembers(lobby)
		
		var btn = Button.new()
		btn.text = "%s\t\t%s" % [lobbyName,memberCount]
		btn.name = "btn_lobby_%s" % lobbyName
		btn.size = Vector2(100,5)
		btn.pressed.connect(join_lobby)
		
		$LobbyContainer/Lobbies.add_child(btn)
