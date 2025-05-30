extends Control


@onready var quit_button: Button = $ButtonsPanel/VBoxContainer/QuitButton


func _enter_tree():
	if OS.get_name() == "HTML5":
		quit_button.visible = false


func _on_play_button_pressed() -> void:
	EventSystem.LEV_change_level.emit(LevelReference.Keys.JumpingArena1)


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
