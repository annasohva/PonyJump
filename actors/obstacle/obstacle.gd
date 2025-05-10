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
		# Adjusting indicator position
		indicator.position.y = (INDICATOR_MAX - INDICATOR_MIN) * indicator_value + INDICATOR_MIN
		
		# Updating indicator color
		match get_indicator_position():
			IndicatorPosition.Default:
				indicator.modulate = Color.WHITE
			IndicatorPosition.Fail:
				indicator.modulate = Color.RED
			IndicatorPosition.Perfect:
				indicator.modulate = Color.BLUE
			IndicatorPosition.TooHigh:
				indicator.modulate = Color.SLATE_GRAY
		
		indicator_value = value

@export_category("Node references")
@export var indicator: Sprite3D
@export var poles: Array[Pole]
@export var landing_pos1: Marker3D
@export var landing_pos2: Marker3D

const INDICATOR_OFFSET: float = 0.35
const INDICATOR_MAX: float = 3
const INDICATOR_MIN: float = 0.2
const PERFECT_RANGE: float = 0.3

enum IndicatorPosition
{
	Default,
	Fail,
	Perfect,
	TooHigh
}


func get_indicator_position() -> IndicatorPosition:
	if indicator.position.y < poles[0].position.y + .001:
		return IndicatorPosition.Default
	elif indicator.position.y < poles[height-1].position.y + INDICATOR_OFFSET:
		return IndicatorPosition.Fail
	elif indicator.position.y < poles[height-1].position.y + PERFECT_RANGE + INDICATOR_OFFSET:
		return IndicatorPosition.Perfect
	else:
		return IndicatorPosition.TooHigh


func _on_jumping_area_1_body_entered(body: Node3D) -> void:
	if body is Horse:
		# Checking that horse is facing the obstacle
		body.jump_landing_pos = landing_pos1.global_position


func _on_jumping_area_2_body_entered(body: Node3D) -> void:
	if body is Horse:
		# Checking that horse is facing the obstacle
		body.jump_landing_pos = landing_pos2.global_position


func _on_jumping_area_body_exited(body: Node3D) -> void:
	if body is Horse:
		body.jump_landing_pos = Vector3.ZERO
