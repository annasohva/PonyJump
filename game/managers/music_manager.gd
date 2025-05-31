extends Node

@export var music_player: AudioStreamPlayer

func _enter_tree() -> void:
	EventSystem.MUS_play_music.connect(play_music)
	EventSystem.MUS_stop_music.connect(stop_music)


func play_music(key: MusicReference.Keys):
	music_player.stream = MusicReference.GetMusic(key)
	music_player.play()


func stop_music():
	music_player.stop()
