extends Node


@export var obstacles: Array[Obstacle]
@export var start_pos: Marker3D
@export var horse: Horse

var current_obstacle: int = 0

var record_time: bool = false
var timer: float = 0
var seconds: int = 0

var faults: int = 0:
	get:
		return faults
	set(value):
		faults = value
		EventSystem.HUD_set_faults_text.emit(str(faults))


func _enter_tree() -> void:
	EventSystem.OBS_charge_jump.connect(charge_jump)
	EventSystem.OBS_jump.connect(handle_jump)
	EventSystem.OBS_crash.connect(handle_crash)
	EventSystem.OBS_restart_course.connect(restart_course)
	EventSystem.OBS_poles_dropped.connect(handle_poles_dropped)


func _ready() -> void:
	start_course()


func start_course() -> void:
	# Setting horse to the starting position
	horse.set_starting_pos(start_pos.global_position, start_pos.global_rotation)
	
	# Activating the first obstacle and setting the hud obstacle text
	obstacles[current_obstacle].set_activate(true)
	EventSystem.HUD_set_obstacle_text.emit("%s/%s" % [current_obstacle, obstacles.size()])
	
	# Starting the timer
	record_time = true


func restart_course() -> void:
	# Resetting the timer
	timer = 0
	EventSystem.HUD_set_timer_text.emit("00:00")
	
	# Resetting faults counter
	faults = 0
	
	# Resetting the obstacles
	reset_obstacles()
	
	# Starting the course again
	start_course()


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


func charge_jump(charge_amount: float) -> void:
	if current_obstacle >= obstacles.size(): return
	obstacles[current_obstacle].indicator_value = charge_amount


func handle_jump(jump_height: float, direction: Vector3) -> void:
	if current_obstacle >= obstacles.size(): return
	obstacles[current_obstacle].handle_jump(jump_height, direction)
	activate_next_obstacle()


func handle_crash(is_active: bool) -> void:
	if is_active:
		activate_next_obstacle()
		faults += 1


func handle_poles_dropped() -> void:
	faults += 1


func activate_next_obstacle() -> void:
	# Setting current obstacle inactive
	obstacles[current_obstacle].set_activate(false)
	
	# Increasing the current_obstacle value to be next obstacle's index
	current_obstacle += 1
	
	# Activating the next obstacle if there is a obstacle at the index in the obstacle array
	if current_obstacle < obstacles.size():
		obstacles[current_obstacle].set_activate(true)
	
	# Emitting the signal to set obstacle text in the hud
	EventSystem.HUD_set_obstacle_text.emit("%s/%s" % [current_obstacle, obstacles.size()])


func _process(delta: float) -> void:
	# Returning if we don't need to record time
	if not record_time: return
	
	# Increasing the timer
	timer += delta
	
	# Checking if the seconds increased by one and if so, emit the signal to set hud timer text
	var old_seconds := seconds
	seconds = floori(timer)
	if seconds > old_seconds:
		var minutes := floori(seconds / 60)
		EventSystem.HUD_set_timer_text.emit("%02d:%02d" % [minutes, seconds - minutes * 60])
