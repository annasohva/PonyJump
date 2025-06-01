class_name OptionsMenu extends Control


@export_group("Gameplay Options References") 
@export_subgroup("Camera Speed X")
@export var camera_speed_x_slider: Slider
@export var camera_speed_x_spin_box: SpinBox

@export_subgroup("Camera Speed Y")
@export var camera_speed_y_slider: Slider
@export var camera_speed_y_spin_box: SpinBox

@export_subgroup("Invert Camera")
@export var camera_invert_x_check_button: CheckButton
@export var camera_invert_y_check_button: CheckButton

@export_subgroup("Perfect Jump Particles")
@export var perfect_jump_particles_check_button: CheckButton

@export_group("Audio Options References") 
@export_subgroup("General Volume")
@export var general_volume_slider: Slider
@export var general_volume_spin_box: SpinBox

@export_subgroup("Music Volume")
@export var music_volume_slider: Slider
@export var music_volume_spin_box: SpinBox

@export_subgroup("SFX Volume")
@export var sfx_volume_slider: Slider
@export var sfx_volume_spin_box: SpinBox

@export_subgroup("Ambience Volume")
@export var ambience_volume_slider: Slider
@export var ambience_volume_spin_box: SpinBox

@export_group("Graphics Options References") 
@export_subgroup("Graphics Options")
@export var game_window_option_button: OptionButton
@export var game_window_hbox: HBoxContainer
@export var fps_option_button: OptionButton
@export var vsync_check_button: CheckButton
@export var anti_aliasing_option_button: OptionButton
@export var shadows_check_button: CheckButton

@export_subgroup("Environment Options")
@export var trees_check_button: CheckButton
@export var foliage_check_button: CheckButton
@export var nature_props_check_button: CheckButton

@onready var gameplay_options: Control = $BackgroundPanel/GameplayOptions
@onready var audio_options: Control = $BackgroundPanel/AudioOptions
@onready var graphics_options: Control = $BackgroundPanel/GraphicsOptions


enum TabKeys
{
	Gameplay,
	Audio,
	Graphics
}


enum GameWindowOptions
{
	Fullscreen,
	Windowed,
}


enum FpsOptions
{
	Uncapped,
	Fps30,
	Fps60,
	Fps120,
	Fps144,
}


enum AntiAliasingOptions
{
	None,
	MSAAx2,
	MSAAx4,
	MSAAx8,
}


func _ready() -> void:
	# Getting the settings dictionary from SettingsManager
	var settings := SettingsManager.Settings
	
	# Gameplay options
	
	# Connecting camera_speed_x_slider value_changed signal
	camera_speed_x_slider.value_changed.connect(func(value):
		camera_speed_x_spin_box.value = value
		EventSystem.SET_set_camera_speed_x.emit(value)
	)
	
	# Connecting camera_speed_x_spin_box value_changed signal
	camera_speed_x_spin_box.value_changed.connect(func(value):
		camera_speed_x_slider.value = value
		EventSystem.SET_set_camera_speed_x.emit(value)
	)
	
	# Loading saved camera_speed_x value
	camera_speed_x_slider.set_value_no_signal(settings.get(
		SettingsManager.CAMERA_SPEED_X_KEY,
		camera_speed_x_slider.value # Using editor value as default
	))
	camera_speed_x_spin_box.set_value_no_signal(camera_speed_x_slider.value)
	
	# Connecting camera_speed_y_slider value_changed signal
	camera_speed_y_slider.value_changed.connect(func(value):
		camera_speed_y_spin_box.value = value
		EventSystem.SET_set_camera_speed_y.emit(value)
	)
	
	# Connecting camera_speed_y_spin_box value_changed signal
	camera_speed_y_spin_box.value_changed.connect(func(value):
		camera_speed_y_slider.value = value
		EventSystem.SET_set_camera_speed_y.emit(value)
	)
	
	# Loading saved camera_speed_y value
	camera_speed_y_slider.set_value_no_signal(settings.get(
		SettingsManager.CAMERA_SPEED_Y_KEY,
		camera_speed_y_slider.value # Using editor value as default
	))
	camera_speed_y_spin_box.set_value_no_signal(camera_speed_y_slider.value)
	
	# Connecting camera_invert_x_check_button toggled signal
	camera_invert_x_check_button.toggled.connect(EventSystem.SET_toggle_camera_invert_x.emit)
	
	# Loading saved camera_invert_x value
	camera_invert_x_check_button.set_pressed_no_signal(settings.get(
		SettingsManager.CAMERA_INVERT_X_KEY,
		camera_invert_x_check_button.button_pressed # Using editor value as default
	))
	
	# Connecting camera_invert_y_check_button toggled signal
	camera_invert_y_check_button.toggled.connect(EventSystem.SET_toggle_camera_invert_y.emit)
	
	# Loading saved camera_invert_y value
	camera_invert_y_check_button.set_pressed_no_signal(settings.get(
		SettingsManager.CAMERA_INVERT_Y_KEY,
		camera_invert_y_check_button.button_pressed # Using editor value as default
	))
	
	# Connecting perfect_jump_particles_check_button toggled signal
	perfect_jump_particles_check_button.toggled.connect(EventSystem.SET_toggle_perfect_jump_particles.emit)
	
	# Loading saved perfect_jump_particles value
	perfect_jump_particles_check_button.set_pressed_no_signal(settings.get(
		SettingsManager.PERFECT_JUMP_PARTICLES_KEY,
		perfect_jump_particles_check_button.button_pressed # Using editor value as default
	))
	
	# Audio options
	
	# Connecting general_volume_slider value_changed signal
	general_volume_slider.value_changed.connect(func(value):
		general_volume_spin_box.value = value
		EventSystem.SET_set_general_volume.emit(value)
	)
	
	# Connecting general_volume_spin_box value_changed signal
	general_volume_spin_box.value_changed.connect(func(value):
		general_volume_slider.value = value
		EventSystem.SET_set_general_volume.emit(value)
	)
	
	# Loading saved general_volume value
	general_volume_slider.set_value_no_signal(settings.get(
		SettingsManager.GENERAL_VOLUME_KEY,
		general_volume_slider.value # Using editor value as default
	))
	general_volume_spin_box.set_value_no_signal(general_volume_slider.value)
	
	# Connecting music_volume_slider value_changed signal
	music_volume_slider.value_changed.connect(func(value):
		music_volume_spin_box.value = value
		EventSystem.SET_set_music_volume.emit(value)
	)
	
	# Connecting music_volume_spin_box value_changed signal
	music_volume_spin_box.value_changed.connect(func(value):
		music_volume_slider.value = value
		EventSystem.SET_set_music_volume.emit(value)
	)
	
	# Loading saved music_volume value
	music_volume_slider.set_value_no_signal(settings.get(
		SettingsManager.MUSIC_VOLUME_KEY,
		music_volume_slider.value # Using editor value as default
	))
	music_volume_spin_box.set_value_no_signal(music_volume_slider.value)
	
	# Connecting sfx_volume_slider value_changed signal
	sfx_volume_slider.value_changed.connect(func(value):
		sfx_volume_spin_box.value = value
		EventSystem.SET_set_sfx_volume.emit(value)
	)
	
	# Connecting sfx_volume_spin_box value_changed signal
	sfx_volume_spin_box.value_changed.connect(func(value):
		sfx_volume_slider.value = value
		EventSystem.SET_set_sfx_volume.emit(value)
	)
	
	# Loading saved sfx_volume value
	sfx_volume_slider.set_value_no_signal(settings.get(
		SettingsManager.SFX_VOLUME_KEY,
		sfx_volume_slider.value # Using editor value as default
	))
	sfx_volume_spin_box.set_value_no_signal(sfx_volume_slider.value)
	
	# Connecting ambience_volume_slider value_changed signal
	ambience_volume_slider.value_changed.connect(func(value):
		ambience_volume_spin_box.value = value
		EventSystem.SET_set_ambience_volume.emit(value)
	)
	
	# Connecting ambience_volume_spin_box value_changed signal
	ambience_volume_spin_box.value_changed.connect(func(value):
		ambience_volume_slider.value = value
		EventSystem.SET_set_ambience_volume.emit(value)
	)
	
	# Loading saved ambience_volume value
	ambience_volume_slider.set_value_no_signal(settings.get(
		SettingsManager.AMBIENCE_VOLUME_KEY,
		ambience_volume_slider.value # Using editor value as default
	))
	ambience_volume_spin_box.set_value_no_signal(ambience_volume_slider.value)
	
	# Graphics options
	
	# Hiding game window option button in web builds
	if OS.has_feature("web"):
		game_window_hbox.visible = false
	else:
		# Loading saved game_window value (loading first because it's not possible to set without signal)
		game_window_option_button.selected = settings.get(
			SettingsManager.GAME_WINDOW_KEY,
			game_window_option_button.selected  # Using editor value as default
		)
		
		# Connecting game_window_option_button item_selected signal
		game_window_option_button.item_selected.connect(EventSystem.SET_set_game_window.emit)
	
	# Loading saved fps value (loading first because it's not possible to set without signal)
	fps_option_button.selected = settings.get(
		SettingsManager.FPS_KEY,
		fps_option_button.selected  # Using editor value as default
	)
	
	# Connecting fps_option_button item_selected signal
	fps_option_button.item_selected.connect(EventSystem.SET_set_fps.emit)
	
	# Connecting vsync_check_button toggled signal
	vsync_check_button.toggled.connect(EventSystem.SET_toggle_vsync.emit)
	
	# Loading saved vsync value
	vsync_check_button.set_pressed_no_signal(settings.get(
		SettingsManager.VSYNC_KEY,
		vsync_check_button.button_pressed # Using editor value as default
	))
	
	# Loading saved anti_aliasing value (loading first because it's not possible to set without signal)
	anti_aliasing_option_button.selected = settings.get(
		SettingsManager.ANTI_ALIASING_KEY,
		anti_aliasing_option_button.selected  # Using editor value as default
	)
	
	# Connecting anti_aliasing_option_button item_selected signal
	anti_aliasing_option_button.item_selected.connect(EventSystem.SET_set_anti_aliasing.emit)
	
	# Connecting shadows_check_button toggled signal
	shadows_check_button.toggled.connect(EventSystem.SET_toggle_shadows.emit)
	
	# Loading saved shadows value
	shadows_check_button.set_pressed_no_signal(settings.get(
		SettingsManager.SHADOWS_KEY,
		shadows_check_button.button_pressed # Using editor value as default
	))
	
	# Connecting trees_check_button toggled signal
	trees_check_button.toggled.connect(EventSystem.SET_toggle_trees.emit)
	
	# Loading saved trees value
	trees_check_button.set_pressed_no_signal(settings.get(
		SettingsManager.TREES_KEY,
		trees_check_button.button_pressed # Using editor value as default
	))
	
	# Connecting foliage_check_button toggled signal
	foliage_check_button.toggled.connect(EventSystem.SET_toggle_foliage.emit)
	
	# Loading saved foliage value
	foliage_check_button.set_pressed_no_signal(settings.get(
		SettingsManager.FOLIAGE_KEY,
		foliage_check_button.button_pressed # Using editor value as default
	))
	
	# Connecting nature_props_check_button toggled signal
	nature_props_check_button.toggled.connect(EventSystem.SET_toggle_nature_props.emit)
	
	# Loading saved nature_props value
	nature_props_check_button.set_pressed_no_signal(settings.get(
		SettingsManager.NATURE_PROPS_KEY,
		nature_props_check_button.button_pressed # Using editor value as default
	))

func _exit_tree() -> void:
	EventSystem.SET_save_settings.emit()


func _on_close_button_pressed() -> void:
	queue_free()


func _on_tab_bar_tab_changed(tab: int) -> void:
	gameplay_options.visible = tab == TabKeys.Gameplay
	audio_options.visible = tab == TabKeys.Audio
	graphics_options.visible = tab == TabKeys.Graphics
