class_name ObstacleCourseManager extends Node


@export var obstacles: Array[Obstacle]
@export var start_pos: Marker3D
@export var horse: Horse

static var CourseComplete: bool = false

var current_obstacle: int = 0

var record_time: bool = false
var countdown: bool = false
var timer: float = 0
var seconds: int = -1

var faults: int = 0:
	get:
		return faults
	set(value):
		faults = value
		EventSystem.HUD_set_faults_text.emit(str(faults))

var score: int = 0:
	get:
		return score
	set(value):
		score = value
		EventSystem.HUD_set_score_text.emit(str(score))


func _enter_tree() -> void:
	EventSystem.OBS_start_course.connect(start_course)
	EventSystem.OBS_countdown_go.connect(handle_countdown_go)
	EventSystem.OBS_charge_jump.connect(charge_jump)
	EventSystem.OBS_jump.connect(handle_jump)
	EventSystem.OBS_crash.connect(handle_crash)
	EventSystem.OBS_reset_course.connect(reset_course)
	EventSystem.OBS_poles_dropped.connect(handle_poles_dropped)
	EventSystem.OBS_points_earned.connect(handle_points_earned)


func _ready() -> void:
	EventSystem.UI_open_menu.emit(UiReference.Keys.JumpingCourse)


func start_course() -> void:
	# Setting horse to the starting position and preventing moving yet
	horse.set_starting_pos(start_pos.global_position, start_pos.global_rotation)
	horse.can_move = false
	
	# Activating the first obstacle and setting the hud obstacle text
	obstacles[current_obstacle].set_activate(true)
	EventSystem.HUD_set_obstacle_text.emit("%s/%s" % [current_obstacle, obstacles.size()])
	
	# Stopping music for the countdown
	EventSystem.MUS_stop_music.emit()
	
	# Starting the countdown
	countdown = true


func reset_course(restart: bool) -> void:
	# Stopping music
	EventSystem.MUS_stop_music.emit()
	
	# Resetting the CourseComplete variable
	CourseComplete = false
	
	# Resetting the timer
	reset_timer()
	
	# Resetting faults and score counter
	faults = 0
	score = 0
	
	# Resetting the obstacles
	reset_obstacles()
	
	# Starting the course again if restart is true
	if restart: start_course()


func reset_obstacles() -> void:
	# Setting the active obstacle inactive
	if current_obstacle < obstacles.size():
		obstacles[current_obstacle].set_activate(false)
	
	# Resetting current_obstacle variable
	if current_obstacle != 0:
		current_obstacle = 0
	
	# Resetting the obstacles so that the poles return to correct positions
	for obstacle in obstacles:
		obstacle.reset()


func reset_timer():
	record_time = false
	countdown = false
	timer = 0
	seconds = -1
	EventSystem.HUD_set_timer_text.emit("00:00")


func show_game_over(delay: float):
	# Emitting signal to show game over screen
	get_tree().create_timer(delay).timeout.connect(func():
		EventSystem.UI_open_menu.emit(UiReference.Keys.GameOver)
	)


func charge_jump(charge_amount: float) -> void:
	if current_obstacle >= obstacles.size(): return
	obstacles[current_obstacle].indicator_value = charge_amount


func handle_countdown_go():
	countdown = false
	reset_timer()
	record_time = true
	horse.can_move = true
	EventSystem.MUS_play_music.emit(MusicReference.Keys.PonyJump)


func handle_jump(jump_height: float, direction: Vector3) -> void:
	if current_obstacle >= obstacles.size(): return
	obstacles[current_obstacle].handle_jump(jump_height, direction)
	activate_next_obstacle()


func handle_crash(is_active: bool) -> void:
	if is_active:
		activate_next_obstacle()
		faults += 1
	else:
		# If crashing into a obstacle which is not active it's the wrong order and game over
		show_game_over(.5)


func handle_poles_dropped() -> void:
	faults += 1


func handle_points_earned(points: int) -> void:
	score += points


func activate_next_obstacle() -> void:
	# Setting current obstacle inactive
	obstacles[current_obstacle].set_activate(false)
	
	# Increasing the current_obstacle value to be next obstacle's index
	current_obstacle += 1
	
	# Activating the next obstacle if there is a obstacle at the index in the obstacle array
	if current_obstacle < obstacles.size():
		obstacles[current_obstacle].set_activate(true)
	else:
		# If there is no more obstacles in the array show game over screen
		CourseComplete = true
		show_game_over(1)
	
	# Emitting the signal to set obstacle text in the hud
	EventSystem.HUD_set_obstacle_text.emit("%s/%s" % [current_obstacle, obstacles.size()])


func _process(delta: float) -> void:
	if record_time or countdown:
		# Increasing the timer
		timer += delta
		
		# Checking if the seconds increased by one and if so, emit the signal to set hud timer text
		var old_seconds := seconds
		seconds = floori(timer)
		if seconds > old_seconds:
			if record_time:
				var minutes := floori(seconds / 60.0)
				EventSystem.HUD_set_timer_text.emit("%02d:%02d" % [minutes, seconds - minutes * 60])
			elif countdown:
				EventSystem.HUD_set_countdown_text.emit(seconds)
