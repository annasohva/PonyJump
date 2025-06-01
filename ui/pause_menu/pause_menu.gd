extends Control


func _enter_tree() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		continue_gameplay()


func continue_gameplay():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()


func _on_continue_button_pressed() -> void:
	continue_gameplay()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	EventSystem.OBS_reset_course.emit(true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()


func _on_options_button_pressed() -> void:
	EventSystem.UI_open_menu.emit(UiReference.Keys.Options)


func _on_jumping_course_button_pressed() -> void:
	EventSystem.OBS_reset_course.emit(false)
	EventSystem.UI_open_menu.emit(UiReference.Keys.JumpingCourse)
	queue_free()


func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	queue_free()
	EventSystem.LEV_change_level.emit(LevelReference.Keys.MainMenu)
