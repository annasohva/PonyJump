@tool
extends Node3D

@export_category("Obstacle settings")
@export_range(1, 5) var height: int = 5:
	get:
		return height
	set(value):
		for i in poles.size():
			poles[i].visible = true if i < value else false
		height = value

@export_range(0,1) var indicator_value: float:
	get:
		return indicator_value
	set(value):
		indicator.position.y = (indicator_max_height - indicator_min_height) * indicator_value + indicator_min_height
		indicator_value = value

@export_category("Indicator settings")
@export var indicator_max_height: float = 2.5
@export var indicator_min_height: float = 0.2

@export_category("Node references")
@export var indicator: Sprite3D
@export var poles: Array[Pole]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
