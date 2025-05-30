extends Control


func _enter_tree() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _exit_tree() -> void:
	get_tree().paused = false


func _on_continue_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()


func _on_restart_button_pressed() -> void:
	EventSystem.OBS_restart_course.emit()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()


func _on_options_button_pressed() -> void:
	EventSystem.UI_open_menu.emit(UiReference.Keys.Options)


func _on_jumping_course_button_pressed() -> void:
	#EventSystem.UI_open_menu.emit(UiReference.Keys.JumpingCourse)
	pass


func _on_exit_button_pressed() -> void:
	queue_free()
	EventSystem.LEV_change_level.emit(LevelReference.Keys.MainMenu)
