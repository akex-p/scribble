extends Node

@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("Effects")

func set_menu():
	AudioServer.set_bus_effect_enabled(MUSIC_BUS_ID, 0, true)
	AudioServer.set_bus_effect_enabled(MUSIC_BUS_ID, 1, true)

func set_game():
	AudioServer.set_bus_effect_enabled(MUSIC_BUS_ID, 0, false)
	AudioServer.set_bus_effect_enabled(MUSIC_BUS_ID, 1, false)