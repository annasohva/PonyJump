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
@export var fps_option_button: OptionButton
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
	NoLimit,
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
	# Gameplay options signals
	
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
	
	# Connecting camera_invert_x_check_button toggled signal
	camera_invert_x_check_button.toggled.connect(EventSystem.SET_toggle_camera_invert_x.emit)
	
	# Connecting camera_invert_y_check_button toggled signal
	camera_invert_y_check_button.toggled.connect(EventSystem.SET_toggle_camera_invert_y.emit)
	
	# Connecting perfect_jump_particles_check_button toggled signal
	perfect_jump_particles_check_button.toggled.connect(EventSystem.SET_toggle_perfect_jump_particles.emit)
	
	# Audio options signals
	
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
	
	# Graphics options signals
	
	# Connecting game_window_option_button item_selected signal
	game_window_option_button.item_selected.connect(EventSystem.SET_set_game_window.emit)
	
	# Connecting fps_option_button item_selected signal
	fps_option_button.item_selected.connect(EventSystem.SET_set_fps.emit)
	
	# Connecting anti_aliasing_option_button item_selected signal
	anti_aliasing_option_button.item_selected.connect(EventSystem.SET_set_anti_aliasing.emit)
	
	# Connecting shadows_check_button toggled signal
	shadows_check_button.toggled.connect(EventSystem.SET_toggle_shadows.emit)
	
	# Connecting trees_check_button toggled signal
	trees_check_button.toggled.connect(EventSystem.SET_toggle_trees.emit)
	
	# Connecting foliage_check_button toggled signal
	foliage_check_button.toggled.connect(EventSystem.SET_toggle_foliage.emit)
	
	# Connecting nature_props_check_button toggled signal
	nature_props_check_button.toggled.connect(EventSystem.SET_toggle_nature_props.emit)


func _on_close_button_pressed() -> void:
	queue_free()


func _on_tab_bar_tab_changed(tab: int) -> void:
	gameplay_options.visible = tab == TabKeys.Gameplay
	audio_options.visible = tab == TabKeys.Audio
	graphics_options.visible = tab == TabKeys.Graphics
