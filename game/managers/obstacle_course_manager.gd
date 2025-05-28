extends Node


@export var obstacles: Array[Obstacle]

var current_obstacle: int = 0

func _ready() -> void:
	EventSystem.OBS_charge_jump.connect(charge_jump)
	EventSystem.OBS_jump.connect(handle_jump)
	EventSystem.OBS_crash.connect(handle_crash)
	obstacles[current_obstacle].set_activate(true)


func charge_jump(charge_amount: float):
	if current_obstacle >= obstacles.size(): return
	obstacles[current_obstacle].indicator_value = charge_amount


func handle_jump(jump_height: float, direction: Vector3):
	if current_obstacle >= obstacles.size(): return
	obstacles[current_obstacle].handle_jump(jump_height, direction)
	activate_next_obstacle()


func handle_crash():
	activate_next_obstacle()


func activate_next_obstacle() -> void:
	obstacles[current_obstacle].set_activate(false)
	current_obstacle += 1
	if current_obstacle >= obstacles.size(): current_obstacle = 0
	obstacles[current_obstacle].set_activate(true)
