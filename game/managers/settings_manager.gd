class_name SettingsManager extends Node


const SETTINGS_PATH := "user://settings.json"

const CAMERA_SPEED_X_KEY := "camera_speed_x"
const CAMERA_SPEED_Y_KEY := "camera_speed_y"
const CAMERA_INVERT_X_KEY := "camera_invert_x"
const CAMERA_INVERT_Y_KEY := "camera_invert_y"
const PERFECT_JUMP_PARTICLES_KEY := "perfect_jump_particles"

const GENERAL_VOLUME_KEY := "general_volume"
const MUSIC_VOLUME_KEY := "music_volume"
const SFX_VOLUME_KEY := "sfx_volume"
const AMBIENCE_VOLUME_KEY := "ambience_volume"

const GAME_WINDOW_KEY := "game_window"
const FPS_KEY := "fps"
const ANTI_ALIASING_KEY := "anti_aliasing"
const SHADOWS_KEY := "shadows"
const TREES_KEY := "trees"
const FOLIAGE_KEY := "foliage"
const NATURE_PROPS_KEY := "nature_props"


static var Settings: Dictionary = {}:
	get:
		# If we already fetched Settings return it
		if Settings.keys().size() > 0: return Settings
		
		# Opening the settings file and checking if it's null
		var settings_file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
		if settings_file == null: return Settings
		
		# Getting settings from the save
		var json := settings_file.get_as_text()
		var parsed_dict: Dictionary = JSON.parse_string(json)
		if parsed_dict != null: Settings = parsed_dict
		settings_file.close()
		
		return Settings
	
	set(value):
		Settings = value


func _enter_tree() -> void:
	EventSystem.SET_save_settings.connect(save_settings)
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


func save_settings() -> void:
	# Checking if we have anything to save
	if Settings.keys().size() == 0: return
	
	# Opening settings_file FileAccess
	var settings_file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if settings_file == null: return
	
	# Turning Settings dictionary to json and saving it
	var json := JSON.stringify(Settings)
	settings_file.store_line(json)
	
	# Closing settings_file
	settings_file.close()


func set_camera_speed_x(new_speed: float) -> void:
	Settings[CAMERA_SPEED_X_KEY] = new_speed


func set_camera_speed_y(new_speed: float) -> void:
	Settings[CAMERA_SPEED_Y_KEY] = new_speed


func set_camera_invert_x(invert: bool) -> void:
	Settings[CAMERA_INVERT_X_KEY] = invert


func set_camera_invert_y(invert: bool) -> void:
	Settings[CAMERA_INVERT_Y_KEY] = invert


func toggle_perfect_jump_particles(show: bool) -> void:
	Settings[PERFECT_JUMP_PARTICLES_KEY] = show


func set_general_volume(new_volume: float) -> void:
	Settings[GENERAL_VOLUME_KEY] = new_volume


func set_music_volume(new_volume: float) -> void:
	Settings[MUSIC_VOLUME_KEY] = new_volume


func set_sfx_volume(new_volume: float) -> void:
	Settings[SFX_VOLUME_KEY] = new_volume


func set_ambience_volume(new_volume: float) -> void:
	Settings[AMBIENCE_VOLUME_KEY] = new_volume


func set_game_window(new_setting: OptionsMenu.GameWindowOptions) -> void:
	Settings[GAME_WINDOW_KEY] = new_setting


func set_fps(new_setting: OptionsMenu.FpsOptions) -> void:
	Settings[FPS_KEY] = new_setting


func set_anti_aliasing(new_setting: OptionsMenu.AntiAliasingOptions) -> void:
	Settings[ANTI_ALIASING_KEY] = new_setting


func toggle_shadows(show: bool) -> void:
	Settings[SHADOWS_KEY] = show


func toggle_trees(show: bool) -> void:
	Settings[TREES_KEY] = show


func toggle_foliage(show: bool) -> void:
	Settings[FOLIAGE_KEY] = show


func toggle_nature_props(show: bool) -> void:
	Settings[NATURE_PROPS_KEY] = show
