extends Control # TODO: Refactor this and pause menu to have base class or be same scene

@onready var game_over_label: Label = $BackgroundPanel/GameOverLabel

const win_text: String = "Course completed!"
const lose_text: String = "Wrong order, try again."


func _enter_tree() -> void:
	EventSystem.MUS_stop_music.emit()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _ready() -> void:
	if ObstacleCourseManager.CourseComplete:
		game_over_label.text = win_text
	else:
		game_over_label.text = lose_text


func _on_play_again_button_pressed() -> void:
	get_tree().paused = false
	EventSystem.OBS_reset_course.emit(true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()


func _on_jumping_course_button_pressed() -> void:
	EventSystem.OBS_reset_course.emit(false)
	EventSystem.UI_open_menu.emit(UiReference.Keys.JumpingCourse)
	queue_free()


func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	queue_free()
	EventSystem.LEV_change_level.emit(LevelReference.Keys.MainMenu)
