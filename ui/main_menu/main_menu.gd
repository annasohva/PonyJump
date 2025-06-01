extends Control


@onready var quit_button: Button = $ButtonsPanel/VBoxContainer/QuitButton


func _ready() -> void:
	EventSystem.MUS_play_music.emit(MusicReference.Keys.PonyJump)
	
	# Hiding quit button in web builds since it doesn't work
	if OS.has_feature("web"):
		quit_button.visible = false


func _on_play_button_pressed() -> void:
	EventSystem.LEV_change_level.emit(LevelReference.Keys.JumpingArena1)


func _on_options_button_pressed() -> void:
	EventSystem.UI_open_menu.emit(UiReference.Keys.Options)


func _on_credits_button_pressed() -> void:
	EventSystem.UI_open_menu.emit(UiReference.Keys.Credits)
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()
