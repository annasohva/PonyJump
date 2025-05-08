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

enum IndicatorPosition
{
	Default,
	Fail,
	Perfect,
	TooHigh
}

const INDICATOR_OFFSET: float = 0.35
const INDICATOR_MAX: float = 3
const INDICATOR_MIN: float = 0.2
const PERFECT_RANGE: float = 0.3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func get_indicator_position() -> IndicatorPosition:
	if indicator.position.y < poles[0].position.y + .001:
		return IndicatorPosition.Default
	elif indicator.position.y < poles[height-1].position.y + INDICATOR_OFFSET:
		return IndicatorPosition.Fail
	elif indicator.position.y < poles[height-1].position.y + PERFECT_RANGE + INDICATOR_OFFSET:
		return IndicatorPosition.Perfect
	else:
		return IndicatorPosition.TooHigh
