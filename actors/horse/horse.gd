class_name Horse extends CharacterBody3D


@onready var spring_arm: SpringArm3D = $Pivot/SpringArm3D
@onready var pivot: Node3D = $Pivot
@onready var obstacle_vision_ray: RayCast3D = $ObstacleVisionRay
@onready var obstacle_crash_area: Area3D = $ObstacleCrashArea
@onready var perfect_particles: CPUParticles3D = $PerfectParticles

enum Gaits
{
	Backward,
	Stop,
	Walk,
	Trot,
	Canter,
	Gallop
}

const CAMERA_CLAMP_DEGREES_X := 45
const TURNING_SPEED := 3
const JUMP_CHARGE_SPEED := 5
const JUMP_VELOCITY := 2
const JUMP_HEIGHT_OFFSET := 0.4

var is_jumping: bool:
	get:
		return jump_curve.point_count != 0
var is_just_landed: bool = false

var can_move: bool = true
var gait_speed: int = 0
var speed: float = 0
var acceleration: float = .5
var current_gait: Gaits = Gaits.Stop

var jump_curve: Curve3D = Curve3D.new()
var current_obstacle: Obstacle = null

var timer: float = 0
var jump_charge: float = 0
var jump_landing_pos: Vector3 = Vector3.ZERO

var camera_speed_x: float = 0.8
var camera_speed_y: float = 0.8

var camera_invert_x: bool = false
var camera_invert_y: bool = false

var camera_rotation: Vector2 = Vector2.ZERO

var can_emit_perfect_particles: bool = true


func _enter_tree() -> void:
	EventSystem.OBS_jumping_area_entered.connect(on_jumping_area_entered)
	EventSystem.OBS_jumping_area_exited.connect(on_jumping_area_exited)
	EventSystem.OBS_perfect_points_earned.connect(on_perfect_points_earned)
	
	# Connecting signals for camera setting updates
	EventSystem.SET_set_camera_speed_x.connect(func(new_speed: float): camera_speed_x = new_speed)
	EventSystem.SET_set_camera_speed_y.connect(func(new_speed: float): camera_speed_y = new_speed)
	EventSystem.SET_toggle_camera_invert_x.connect(func(invert: bool): camera_invert_x = invert)
	EventSystem.SET_toggle_camera_invert_y.connect(func(invert: bool): camera_invert_y = invert)
	
	# Connecting signal for perfect particle setting updates
	EventSystem.SET_toggle_perfect_jump_particles.connect(func(toggle: bool): can_emit_perfect_particles = toggle)


func _ready() -> void:
	# Signal to open hud
	EventSystem.UI_open_menu.emit(UiReference.Keys.PlayerHud)
	
	# Getting camera settings from SettingsManager
	if SettingsManager.Settings.has(SettingsManager.CAMERA_SPEED_X_KEY):
		camera_speed_x = SettingsManager.Settings.get(SettingsManager.CAMERA_SPEED_X_KEY)
	
	if SettingsManager.Settings.has(SettingsManager.CAMERA_SPEED_Y_KEY):
		camera_speed_y = SettingsManager.Settings.get(SettingsManager.CAMERA_SPEED_Y_KEY)
	
	if SettingsManager.Settings.has(SettingsManager.CAMERA_INVERT_X_KEY):
		camera_invert_x = SettingsManager.Settings.get(SettingsManager.CAMERA_INVERT_X_KEY)
	
	if SettingsManager.Settings.has(SettingsManager.CAMERA_INVERT_Y_KEY):
		camera_invert_y = SettingsManager.Settings.get(SettingsManager.CAMERA_INVERT_Y_KEY)
	
	# Getting perfect particle setting from SettingsManager
	if SettingsManager.Settings.has(SettingsManager.PERFECT_JUMP_PARTICLES_KEY):
		can_emit_perfect_particles = SettingsManager.Settings.get(SettingsManager.PERFECT_JUMP_PARTICLES_KEY)
	
	# Emitting the particles so that they don't cause lag on the first jump
	perfect_particles.emitting = can_emit_perfect_particles


func set_starting_pos(pos_global: Vector3, rotation_global: Vector3) -> void:
	# Setting position and rotation
	global_position = pos_global
	global_rotation = rotation_global
	
	# Setting camera to default pos
	camera_rotation.y = rotation_degrees.y
	camera_rotation.x = -30
	
	# Stopping horse movement
	if current_gait == Gaits.Stop: return
	current_gait = Gaits.Stop
	adjust_speed()
	speed = 0
	velocity = Vector3.ZERO


func _input(event: InputEvent) -> void:
	# Pressing escape opens pause menu
	if event.is_action_pressed("escape"):
		EventSystem.UI_open_menu.emit(UiReference.Keys.PauseMenu)
	
	if event is InputEventMouseMotion:
		# Calculating how much camera should move and checking if should move inverted
		if camera_invert_x:
			camera_rotation.x += event.relative.y * camera_speed_x
		else:
			camera_rotation.x -= event.relative.y * camera_speed_x
		
		if camera_invert_y:
			camera_rotation.y += event.relative.x * camera_speed_y
		else:
			camera_rotation.y -= event.relative.x * camera_speed_y
		
		# Clamping camera rotation
		camera_rotation.x = clamp(camera_rotation.x, -CAMERA_CLAMP_DEGREES_X, CAMERA_CLAMP_DEGREES_X)
	
	# Increasing gait if pressing forward
	if event.is_action_pressed("forward") && can_move:
		current_gait = clamp(current_gait + 1, Gaits.Backward, Gaits.Gallop)
		adjust_speed()
	
	# Decreasing gait if pressing backward
	if event.is_action_pressed("backward") && can_move:
		current_gait = clamp(current_gait - 1, Gaits.Backward, Gaits.Gallop)
		adjust_speed()
	
	# If mouse is not captured when screen is clicked capture it
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func adjust_speed():
	match current_gait:
		Gaits.Backward:
			gait_speed = -3
		Gaits.Stop:
			gait_speed = 0
		Gaits.Walk:
			gait_speed = 5
		Gaits.Trot:
			gait_speed = 10
		Gaits.Canter:
			gait_speed = 15
		Gaits.Gallop:
			gait_speed = 20
	
	EventSystem.HUD_set_gait_text.emit(current_gait)


func on_jumping_area_entered(obstacle: Obstacle, landing_pos: Vector3):
	jump_landing_pos = landing_pos
	current_obstacle = obstacle


func on_jumping_area_exited():
	jump_landing_pos = Vector3.ZERO
	if not (is_jumping):
		current_obstacle = null
		if (is_just_landed): obstacle_crash_area.set_deferred("monitorable", true)
	is_just_landed = false


func on_perfect_points_earned():
	perfect_particles.emitting = can_emit_perfect_particles


func calculate_jump_curve():
	jump_curve.clear_points()
	if jump_landing_pos == Vector3.ZERO: return
	
	# Calculating jump landing position so that it is in the same direction as horse is going
	var jump_length := (jump_landing_pos - global_position).length()
	jump_landing_pos = -global_transform.basis.z.normalized() * jump_length + global_position
	
	# Calculating jump height position
	# Getting the highest mid point of the jump for the obstacle
	var distance_to_obstacle := (current_obstacle.global_position - global_position).length()
	var jump_pos_weight := distance_to_obstacle / jump_length
	var jump_height_pos := global_position.lerp(jump_landing_pos, jump_pos_weight)
	
	# Clamping jump charge so that the horse won't jump 5 meters high when held long
	jump_charge = clamp(jump_charge, 0, current_obstacle.indicator_max)
	jump_height_pos.y += jump_charge + JUMP_HEIGHT_OFFSET
	
	# Adding jump trajectory points to the curve
	jump_curve.add_point(global_position)
	jump_curve.add_point(jump_height_pos, transform.basis.z.normalized(), -transform.basis.z.normalized())
	jump_curve.add_point(jump_landing_pos)
	
	# Emitting the jump signal
	EventSystem.OBS_jump.emit(jump_height_pos.y - JUMP_HEIGHT_OFFSET, -transform.basis.z.normalized())


func can_jump() -> bool:
	return is_on_floor() \
	and current_gait > Gaits.Walk \
	and current_obstacle != null \
	and obstacle_vision_ray.is_colliding() \
	and obstacle_vision_ray.get_collider().get_parent() == current_obstacle


func _physics_process(delta: float) -> void:
	# Handle jump.
	if Input.is_action_pressed("jump"):
		jump_charge += delta * JUMP_CHARGE_SPEED
	
	if Input.is_action_just_released("jump"):
		if can_jump():
			obstacle_crash_area.monitorable = false
			calculate_jump_curve()
		jump_charge = 0
	
	EventSystem.OBS_charge_jump.emit(jump_charge)
	
	if (is_jumping): # Update horse position while jumping
		timer += delta * JUMP_VELOCITY
		global_position = jump_curve.sample_baked(timer * jump_curve.get_baked_length())
		
		if (global_position - jump_curve.get_point_position(jump_curve.point_count-1)).length() < 0.1:
			timer = 0
			current_obstacle = null
			is_just_landed = true
			jump_curve.clear_points()
	
	else: # If not jumping, handle movement
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		# Handle turning
		var turn_dir := Input.get_axis("left", "right")
		if turn_dir && can_move:
			rotate_y(-deg_to_rad(turn_dir * TURNING_SPEED))
		
		# Calculate speed and velocity
		speed = move_toward(speed, gait_speed, acceleration)
		
		var direction := -transform.basis.z.normalized() * speed
		velocity.x = direction.x
		velocity.z = direction.z
	
	move_and_slide()
	
	# Rotate and move camera
	spring_arm.rotation_degrees.x = camera_rotation.x
	pivot.rotation_degrees.y = camera_rotation.y
	pivot.global_position.x = global_position.x
	pivot.global_position.z = global_position.z
