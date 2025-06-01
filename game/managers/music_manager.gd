extends Node


@export var music_player: AudioStreamPlayer

var music_bus_index: int


func _enter_tree() -> void:
	EventSystem.MUS_play_music.connect(play_music)
	EventSystem.MUS_stop_music.connect(stop_music)
	EventSystem.SET_set_general_volume.connect(set_general_volume)
	EventSystem.SET_set_music_volume.connect(set_music_volume)


func _ready() -> void:
	# Finding music bus
	music_bus_index = AudioServer.get_bus_index(music_player.bus)
	
	# Loading audio settings from SettingsManager and setting volume
	if SettingsManager.Settings.has(SettingsManager.GENERAL_VOLUME_KEY):
		set_general_volume(SettingsManager.Settings.get(SettingsManager.GENERAL_VOLUME_KEY))
	if SettingsManager.Settings.has(SettingsManager.MUSIC_VOLUME_KEY):
		set_general_volume(SettingsManager.Settings.get(SettingsManager.MUSIC_VOLUME_KEY))


func play_music(key: MusicReference.Keys):
	music_player.stream = MusicReference.GetMusic(key)
	music_player.play()


func stop_music():
	music_player.stop()


func set_general_volume(new_volume: float):
	AudioServer.set_bus_volume_db(0, linear_to_db(new_volume / 100))


func set_music_volume(new_volume: float):
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(new_volume / 100))
