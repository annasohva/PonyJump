extends Node


@export var obstacles: Array[Obstacle]
@export var start_pos: Marker3D
@export var horse: Horse

var current_obstacle: int = 0


func _enter_tree() -> void:
	EventSystem.OBS_charge_jump.connect(charge_jump)
	EventSystem.OBS_jump.connect(handle_jump)
	EventSystem.OBS_crash.connect(handle_crash)
	EventSystem.OBS_restart_course.connect(restart_course)


func _ready() -> void:
	start_course()


func start_course():
	horse.set_starting_pos(start_pos.global_position, start_pos.global_rotation)
	if current_obstacle != 0:
		obstacles[current_obstacle].set_activate(false)
		current_obstacle = 0
	obstacles[current_obstacle].set_activate(true)


func restart_course():
	reset_obstacles()
	start_course()


func reset_obstacles():
	for obstacle in obstacles:
		obstacle.reset()


func charge_jump(charge_amount: float):
	if current_obstacle >= obstacles.size(): return
	obstacles[current_obstacle].indicator_value = charge_amount


func handle_jump(jump_height: float, direction: Vector3):
	if current_obstacle >= obstacles.size(): return
	obstacles[current_obstacle].handle_jump(jump_height, direction)
	activate_next_obstacle()


func handle_crash(is_active: bool):
	if is_active:
		activate_next_obstacle()


func activate_next_obstacle() -> void:
	obstacles[current_obstacle].set_activate(false)
	current_obstacle += 1
	if current_obstacle >= obstacles.size(): current_obstacle = 0
	obstacles[current_obstacle].set_activate(true)
