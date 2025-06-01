class_name SettingsManager extends Node

var hud: Control

func _enter_tree() -> void:
	EventSystem.SET_set_camera_speed_x.connect(set_camera_speed_x)
	EventSystem.SET_set_camera_speed_y.connect(set_camera_speed_y)
	EventSystem.SET_toggle_camera_invert_x.connect(set_camera_invert_x)
	EventSystem.SET_toggle_camera_invert_y.connect(set_camera_invert_y)
	EventSystem.SET_toggle_perfect_jump_particles.connect(toggle_perfect_jump_particles)
	EventSystem.SET_set_general_volume.connect(set_general_volume)
	EventSystem.SET_set_music_volume.connect(set_music_volume)
	EventSystem.SET_set_sfx_volume.connect(set_sfx_volume)
	EventSystem.SET_set_ambience_volume.connect(set_ambience_volume)
	EventSystem.SET_set_game_window.connect(set_game_window)
	EventSystem.SET_set_fps.connect(set_fps)
	EventSystem.SET_set_anti_aliasing.connect(set_anti_aliasing)
	EventSystem.SET_toggle_shadows.connect(toggle_shadows)
	EventSystem.SET_toggle_trees.connect(toggle_trees)
	EventSystem.SET_toggle_foliage.connect(toggle_foliage)
	EventSystem.SET_toggle_nature_props.connect(toggle_nature_props)


func set_camera_speed_x(new_speed: float):
	pass


func set_camera_speed_y(new_speed: float):
	pass


func set_camera_invert_x(invert: bool):
	pass


func set_camera_invert_y(invert: bool):
	pass


func toggle_perfect_jump_particles(show: bool):
	pass


func set_general_volume(new_volume: float):
	pass


func set_music_volume(new_volume: float):
	pass


func set_sfx_volume(new_volume: float):
	pass


func set_ambience_volume(new_volume: float):
	pass


func set_game_window(new_setting: OptionsMenu.GameWindowOptions):
	pass


func set_fps(new_setting: OptionsMenu.FpsOptions):
	pass


func set_anti_aliasing(new_setting: OptionsMenu.AntiAliasingOptions):
	pass


func toggle_shadows(show: bool):
	pass


func toggle_trees(show: bool):
	pass


func toggle_foliage(show: bool):
	pass


func toggle_nature_props(show: bool):
	pass
