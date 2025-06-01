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
const VSYNC_KEY := "vsync"
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
	EventSystem.SET_set_camera_speed_x.connect(handle_set_camera_speed_x)
	EventSystem.SET_set_camera_speed_y.connect(handle_set_camera_speed_y)
	EventSystem.SET_toggle_camera_invert_x.connect(handle_set_camera_invert_x)
	EventSystem.SET_toggle_camera_invert_y.connect(handle_set_camera_invert_y)
	EventSystem.SET_toggle_perfect_jump_particles.connect(handle_toggle_perfect_jump_particles)
	EventSystem.SET_set_general_volume.connect(handle_set_general_volume)
	EventSystem.SET_set_music_volume.connect(handle_set_music_volume)
	EventSystem.SET_set_sfx_volume.connect(handle_set_sfx_volume)
	EventSystem.SET_set_ambience_volume.connect(handle_set_ambience_volume)
	EventSystem.SET_set_game_window.connect(handle_set_game_window)
	EventSystem.SET_set_fps.connect(handle_set_fps)
	EventSystem.SET_toggle_vsync.connect(handle_toggle_vsync)
	EventSystem.SET_set_anti_aliasing.connect(handle_set_anti_aliasing)
	EventSystem.SET_toggle_shadows.connect(handle_toggle_shadows)
	EventSystem.SET_toggle_trees.connect(handle_toggle_trees)
	EventSystem.SET_toggle_foliage.connect(handle_toggle_foliage)
	EventSystem.SET_toggle_nature_props.connect(handle_toggle_nature_props)


func _ready():
	var settings_dict = Settings
	
	# Loading the saved Audio settings
	if settings_dict.has(GENERAL_VOLUME_KEY):
		set_general_volume(settings_dict.get(GENERAL_VOLUME_KEY))
	
	if settings_dict.has(MUSIC_VOLUME_KEY):
		set_music_volume(settings_dict.get(MUSIC_VOLUME_KEY))
	
	if settings_dict.has(SFX_VOLUME_KEY):
		set_sfx_volume(settings_dict.get(SFX_VOLUME_KEY))
	
	if settings_dict.has(AMBIENCE_VOLUME_KEY):
		set_ambience_volume(settings_dict.get(AMBIENCE_VOLUME_KEY))
	
	# Loading the saved Graphics settings which need to be applied from this script
	if settings_dict.has(GAME_WINDOW_KEY) and !OS.has_feature("web"):
		set_game_window(settings_dict.get(GAME_WINDOW_KEY))
	
	if settings_dict.has(FPS_KEY):
		set_fps(settings_dict.get(FPS_KEY))
	
	if settings_dict.has(VSYNC_KEY):
		toggle_vsync(settings_dict.get(VSYNC_KEY))
	
	if settings_dict.has(ANTI_ALIASING_KEY):
		set_anti_aliasing(settings_dict.get(ANTI_ALIASING_KEY))


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


# Handle methods save the setting and call the setting method
func handle_set_camera_speed_x(new_speed: float) -> void:
	Settings[CAMERA_SPEED_X_KEY] = new_speed
	set_camera_speed_x(new_speed)


# Setting methods implement the setting's functionality
func set_camera_speed_x(new_speed: float) -> void:
	pass


func handle_set_camera_speed_y(new_speed: float) -> void:
	Settings[CAMERA_SPEED_Y_KEY] = new_speed
	set_camera_speed_y(new_speed)


func set_camera_speed_y(new_speed: float) -> void:
	pass


func handle_set_camera_invert_x(invert: bool) -> void:
	Settings[CAMERA_INVERT_X_KEY] = invert
	set_camera_invert_x(invert)


func set_camera_invert_x(invert: bool) -> void:
	pass


func handle_set_camera_invert_y(invert: bool) -> void:
	Settings[CAMERA_INVERT_Y_KEY] = invert
	set_camera_invert_y(invert)


func set_camera_invert_y(invert: bool) -> void:
	pass


func handle_toggle_perfect_jump_particles(show: bool) -> void:
	Settings[PERFECT_JUMP_PARTICLES_KEY] = show
	toggle_perfect_jump_particles(show)


func toggle_perfect_jump_particles(show: bool) -> void:
	pass


func handle_set_general_volume(new_volume: float) -> void:
	Settings[GENERAL_VOLUME_KEY] = new_volume
	set_general_volume(new_volume)


func set_general_volume(new_volume: float) -> void:
	pass


func handle_set_music_volume(new_volume: float) -> void:
	Settings[MUSIC_VOLUME_KEY] = new_volume
	set_music_volume(new_volume)


func set_music_volume(new_volume: float) -> void:
	pass


func handle_set_sfx_volume(new_volume: float) -> void:
	Settings[SFX_VOLUME_KEY] = new_volume
	set_sfx_volume(new_volume)


func set_sfx_volume(new_volume: float) -> void:
	pass


func handle_set_ambience_volume(new_volume: float) -> void:
	Settings[AMBIENCE_VOLUME_KEY] = new_volume
	set_ambience_volume(new_volume)


func set_ambience_volume(new_volume: float) -> void:
	pass


func handle_set_game_window(new_setting: OptionsMenu.GameWindowOptions) -> void:
	Settings[GAME_WINDOW_KEY] = new_setting
	set_game_window(new_setting)


func set_game_window(new_setting: OptionsMenu.GameWindowOptions) -> void:
	match new_setting:
		OptionsMenu.GameWindowOptions.Fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		OptionsMenu.GameWindowOptions.Windowed:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func handle_set_fps(new_setting: OptionsMenu.FpsOptions) -> void:
	Settings[FPS_KEY] = new_setting
	set_fps(new_setting)


func set_fps(new_setting: OptionsMenu.FpsOptions) -> void:
	match new_setting:
		OptionsMenu.FpsOptions.Uncapped:
			Engine.max_fps = 0
		OptionsMenu.FpsOptions.Fps30:
			Engine.max_fps = 30
		OptionsMenu.FpsOptions.Fps60:
			Engine.max_fps = 60
		OptionsMenu.FpsOptions.Fps120:
			Engine.max_fps = 120
		OptionsMenu.FpsOptions.Fps144:
			Engine.max_fps = 144


func handle_toggle_vsync(toggle: bool) -> void:
	Settings[VSYNC_KEY] = toggle
	toggle_vsync(toggle)


func toggle_vsync(toggle: bool) -> void:
	if toggle:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func handle_set_anti_aliasing(new_setting: OptionsMenu.AntiAliasingOptions) -> void:
	Settings[ANTI_ALIASING_KEY] = new_setting
	set_anti_aliasing(new_setting)


func set_anti_aliasing(new_setting: OptionsMenu.AntiAliasingOptions) -> void:
	var viewport_msaa := Viewport.MSAA_DISABLED
	
	match new_setting:
		OptionsMenu.AntiAliasingOptions.MSAAx2:
			viewport_msaa = Viewport.MSAA_2X
		OptionsMenu.AntiAliasingOptions.MSAAx4:
			viewport_msaa = Viewport.MSAA_4X
		OptionsMenu.AntiAliasingOptions.MSAAx8:
			viewport_msaa = Viewport.MSAA_8X
	
	get_viewport().msaa_3d = viewport_msaa


func handle_toggle_shadows(show: bool) -> void:
	Settings[SHADOWS_KEY] = show
	toggle_shadows(show)


func toggle_shadows(show: bool) -> void:
	pass


func handle_toggle_trees(show: bool) -> void:
	Settings[TREES_KEY] = show
	toggle_trees(show)


func toggle_trees(show: bool) -> void:
	pass


func handle_toggle_foliage(show: bool) -> void:
	Settings[FOLIAGE_KEY] = show
	toggle_foliage(show)


func toggle_foliage(show: bool) -> void:
	pass


func handle_toggle_nature_props(show: bool) -> void:
	Settings[NATURE_PROPS_KEY] = show
	toggle_nature_props(show)


func toggle_nature_props(show: bool) -> void:
	pass
