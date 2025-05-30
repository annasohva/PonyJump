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
@export_range(1,2) var jumping_area: int = 1:
	get:
		return jumping_area
	set(value):
		jumping_area = value
		jumping_area_1_indicator.visible = value == 1
		jumping_area_2_indicator.visible = value == 2

@export_category("Node references")
@export var indicator: Sprite3D
@export var poles: Array[Pole]
@export var landing_pos1: Marker3D
@export var landing_pos2: Marker3D
@export var jumping_area_1_indicator: MeshInstance3D
@export var jumping_area_2_indicator: MeshInstance3D
@export var obstacle_area: Area3D


enum IndicatorPosition
{
	Default,
	Fail,
	Perfect,
	TooHigh
}

const INDICATOR_OFFSET: float = 0.2
const PERFECT_RANGE: float = 0.3

var is_active: bool = false

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
		indicator.position.y = indicator_value + INDICATOR_OFFSET
		
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


func _enter_tree() -> void:
	# If in editor setting jumping area indicators visible if the chosen jumping area matches
	if Engine.is_editor_hint():
		jumping_area_1_indicator.visible = jumping_area == 1
		jumping_area_2_indicator.visible = jumping_area == 2
		return
	
	# If in game setting jumping area indicators active according to active status and if the chosen jumping area matches
	jumping_area_1_indicator.visible = is_active && jumping_area == 1
	jumping_area_2_indicator.visible = is_active && jumping_area == 2


func handle_jump(jump_height: float, direction: Vector3) -> void:
	# Dropping the poles which are too high
	var poles_dropped := 0
	for pole in poles:
		if pole.visible && !pole.is_dropped:
			if pole.position.y >= jump_height:
				pole.drop(direction)
				poles_dropped += 1
				pole.is_dropped = true
	
	# Updating the obstacle height after 3 sec to hide dropped poles
	if poles_dropped > 0: adjust_height_after_delay(height - poles_dropped, 3)


func set_activate(activate: bool) -> void:
	indicator_value = 0
	indicator.visible = activate
	is_active = activate
	
	# Setting jumping area indicators and areas
	jumping_area_1_indicator.visible = activate && jumping_area == 1
	jumping_area_2_indicator.visible = activate && jumping_area == 2


func get_indicator_position() -> IndicatorPosition:
	var indicator_pos := indicator.position.y - INDICATOR_OFFSET
	
	if indicator_pos < poles[0].position.y + .001:
		return IndicatorPosition.Default
	elif indicator_pos < get_obstacle_height():
		return IndicatorPosition.Fail
	elif indicator_pos < get_obstacle_height() + PERFECT_RANGE:
		return IndicatorPosition.Perfect
	else:
		return IndicatorPosition.TooHigh


func get_obstacle_height() -> float:
	return poles[height-1].position.y


func adjust_height_after_delay(new_height: int, delay: float):
	get_tree().create_timer(delay, false, true).timeout.connect(func(): height = new_height)


func _on_jumping_area_1_body_entered(body: Node3D) -> void:
	if body is Horse:
		if is_active:
			EventSystem.OBS_jumping_area_entered.emit(self, landing_pos1.global_position)


func _on_jumping_area_2_body_entered(body: Node3D) -> void:
	if body is Horse:
		if is_active:
			EventSystem.OBS_jumping_area_entered.emit(self, landing_pos2.global_position)


func _on_jumping_area_body_exited(body: Node3D) -> void:
	if body is Horse:
		EventSystem.OBS_jumping_area_exited.emit()


func _on_obstacle_area_entered(area: Area3D) -> void:
	var area_parent = area.get_parent()
	
	if area.get_parent() is Horse:
		if area_parent.is_jumping or area_parent.is_just_landed: return
		EventSystem.OBS_crash.emit(is_active)
		
		for pole in poles:
			if pole.visible && !pole.is_dropped:
				pole.crash(-area_parent.transform.basis.z)
				pole.is_dropped = true
		
		adjust_height_after_delay(0, 3)
