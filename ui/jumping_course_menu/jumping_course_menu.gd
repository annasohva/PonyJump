extends Control


func _enter_tree() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _exit_tree() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_play_button_pressed() -> void:
	EventSystem.OBS_start_course.emit()
	queue_free()
