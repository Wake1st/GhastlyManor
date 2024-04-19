extends Node


func _ready():
	OS.set_environment("SteamAppID",str(420))
	OS.set_environment("SteamGameID",str(420))
	Steam.steamInitEx()


func _process(_delta):
	Steam.run_callbacks()
