extends Node


@export var obstacles: Array[Obstacle]

var current_obstacle: int = 0

func _ready() -> void:
	EventSystem.OBS_charge_jump.connect(charge_jump)
	EventSystem.OBS_jumped.connect(handle_jump)
	obstacles[current_obstacle].set_activate(true)


func charge_jump(charge_amount: float):
	if current_obstacle >= obstacles.size(): return
	obstacles[current_obstacle].indicator_value = charge_amount


func handle_jump(jump_height: float):
	if current_obstacle >= obstacles.size(): return
	obstacles[current_obstacle].handle_jump(jump_height)
	activate_next_obstacle()


func activate_next_obstacle() -> void:
	current_obstacle += 1
	if current_obstacle >= obstacles.size(): current_obstacle = 0
	obstacles[current_obstacle].set_activate(true)
