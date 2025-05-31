extends Control


func _enter_tree() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	EventSystem.UI_toggle_hud.emit(false)


func _exit_tree() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EventSystem.UI_toggle_hud.emit(true)


func _on_play_button_pressed() -> void:
	EventSystem.OBS_start_course.emit()
	queue_free()
