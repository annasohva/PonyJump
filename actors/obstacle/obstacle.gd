@tool
class_name Obstacle extends Node3D


@export_category("Obstacle settings")
@export_range(1, 5) var height: int = 5:
	get:
		return height
	set(value):
		for i in poles.size():
			poles[i].visible = true if i < value else false
		height = value

@export_category("Node references")
@export var indicator: Sprite3D
@export var poles: Array[Pole]
@export var landing_pos1: Marker3D
@export var landing_pos2: Marker3D

enum IndicatorPosition
{
	Default,
	Fail,
	Perfect,
	TooHigh
}

enum StatusType
{
	Inactive,
	Active,
	IsJumped,
	Landed
}

const INDICATOR_OFFSET: float = 0.2
const PERFECT_RANGE: float = 0.3

var current_status: StatusType = StatusType.Inactive

var indicator_max: float:
	get:
		return get_obstacle_height() + 1

var indicator_min: float:
	get:
		return poles[0].position.y -.1

var indicator_value: float:
	get:
		return indicator_value
	set(value):
		indicator_value = clamp(value, indicator_min, indicator_max)
		
		# Adjusting indicator position
		indicator.position.y = indicator_value
		
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


func handle_jump(jump_height: float, direction: Vector3) -> void:
	# Setting status being jumped
	current_status = StatusType.IsJumped
	
	# Dropping the poles which are too high
	var poles_dropped := 0
	for pole in poles:
		if pole.visible && !pole.is_dropped:
			if pole.position.y >= jump_height:
				pole.drop(direction)
				poles_dropped += 1
				pole.is_dropped = true
	
	# Updating the obstacle height after 3 sec to hide dropped poles
	if poles_dropped > 0: get_tree().create_timer(3, false, true).timeout.connect(func(): height -= poles_dropped)


func set_activate(activate: bool) -> void:
	indicator_value = 0
	indicator.visible = activate
	if activate:
		current_status = StatusType.Active


func get_indicator_position() -> IndicatorPosition:
	if indicator.position.y < poles[0].position.y + .001:
		return IndicatorPosition.Default
	elif indicator.position.y < get_obstacle_height() + INDICATOR_OFFSET:
		return IndicatorPosition.Fail
	elif indicator.position.y < get_obstacle_height() + PERFECT_RANGE + INDICATOR_OFFSET:
		return IndicatorPosition.Perfect
	else:
		return IndicatorPosition.TooHigh


func get_obstacle_height() -> float:
	return poles[height-1].position.y


func _on_jumping_area_1_body_entered(body: Node3D) -> void:
	if body is Horse:
		if current_status == StatusType.Active:
			EventSystem.OBS_jumping_area_entered.emit(self, landing_pos1.global_position)


func _on_jumping_area_2_body_entered(body: Node3D) -> void:
	if body is Horse:
		if current_status == StatusType.Active:
			EventSystem.OBS_jumping_area_entered.emit(self, landing_pos2.global_position)


func _on_jumping_area_body_exited(body: Node3D) -> void:
	if body is Horse:
		EventSystem.OBS_jumping_area_exited.emit()
		if current_status == StatusType.Landed:
			current_status = StatusType.Inactive


func _on_obstacle_area_body_entered(body: Node3D) -> void:
	if body is Horse:
		print(current_status)
		if current_status == StatusType.Inactive or current_status == StatusType.Active:
			EventSystem.OBS_crash.emit(current_status == StatusType.Active)
			for pole in poles:
				if pole.visible && !pole.is_dropped:
					pole.crash(-body.transform.basis.z)
					pole.is_dropped = true
