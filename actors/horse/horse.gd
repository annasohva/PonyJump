class_name Horse extends CharacterBody3D


@onready var spring_arm: SpringArm3D = $Pivot/SpringArm3D
@onready var pivot: Node3D = $Pivot
@onready var obstacle_vision_ray: RayCast3D = $ObstacleVisionRay

var is_jumping: bool:
	get:
		return jump_curve.point_count != 0

var gait_speed: int = 0
var speed: float = 0
var acceleration: float = .5

var current_gait: Gaits = Gaits.Stop
var jump_curve: Curve3D = Curve3D.new()
var obstacle_height: float = 0
var current_obstacle: Obstacle = null

var timer: float = 0
var jump_charge: float = 0

const TURNING_SPEED := 3
const CAMERA_SPEED := 0.8
const JUMP_CHARGE_SPEED := 4
const JUMP_VELOCITY := 2
const JUMP_HEIGHT_OFFSET := 0.4

enum Gaits
{
	Back = -1,
	Stop = 0,
	Walk = 1,
	Trot = 2,
	Canter = 3,
	Gallop = 4
}

var camera_rotation: Vector2 = Vector2.ZERO
var jump_landing_pos: Vector3 = Vector3.ZERO


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _enter_tree() -> void:
	EventSystem.OBS_jumping_area_entered.connect(on_jumping_area_entered)
	EventSystem.OBS_jumping_area_exited.connect(on_jumping_area_exited)


func _exit_tree() -> void:
	EventSystem.OBS_jumping_area_entered.connect(on_jumping_area_entered)
	EventSystem.OBS_jumping_area_exited.connect(on_jumping_area_exited)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()
		
	if event is InputEventMouseMotion:
		camera_rotation.x -= event.relative.y
		camera_rotation.y -= event.relative.x
	
	if event.is_action_pressed("forward"):
		current_gait = clamp(current_gait + 1, Gaits.Back, Gaits.Gallop)
		adjust_speed()
	
	if event.is_action_pressed("backward"):
		current_gait = clamp(current_gait - 1, Gaits.Back, Gaits.Gallop)
		adjust_speed()
	
	if Input.is_action_just_released("jump"):
		jump_charge = 0


func adjust_speed():
	match current_gait:
		Gaits.Back:
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


func on_jumping_area_entered(obstacle: Obstacle, landing_pos: Vector3):
	obstacle_height = obstacle.get_obstacle_height()
	jump_landing_pos = landing_pos
	current_obstacle = obstacle


func on_jumping_area_exited():
	obstacle_height = 0
	jump_landing_pos = Vector3.ZERO
	current_obstacle = null


func calculate_jump_curve():
	jump_curve.clear_points()
	if jump_landing_pos == Vector3.ZERO: return
	
	# Calculating jump landing position so that it is in the same direction as horse is going
	var jump_length := (jump_landing_pos - global_position).length()
	jump_landing_pos = -global_transform.basis.z.normalized() * jump_length + global_position
	
	# Calculating jump height position
	var distance_to_obstacle := (current_obstacle.global_position - global_position).length()
	var jump_pos_weight := distance_to_obstacle / jump_length
	var jump_height_pos := global_position.lerp(jump_landing_pos, jump_pos_weight)
	jump_height_pos.y += obstacle_height + JUMP_HEIGHT_OFFSET
	
	# Adding jump trajectory points to the curve
	jump_curve.add_point(global_position)
	jump_curve.add_point(jump_height_pos, transform.basis.z.normalized(), -transform.basis.z.normalized())
	jump_curve.add_point(jump_landing_pos)


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
	
	if Input.is_action_just_pressed("jump") and can_jump():
		calculate_jump_curve()
	
	if (is_jumping): # Update horse position while jumping
		timer += delta * JUMP_VELOCITY
		global_position = jump_curve.sample_baked(timer * jump_curve.get_baked_length())
		
		if (global_position - jump_curve.get_point_position(jump_curve.point_count-1)).length() < 0.1:
			timer = 0
			jump_curve.clear_points()
	else: # If not jumping, handle movement
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		# Handle turning
		var turn_dir := Input.get_axis("left", "right")
		if turn_dir:
			rotate_y(-deg_to_rad(turn_dir * TURNING_SPEED))
		
		# Calculate speed and velocity
		speed = move_toward(speed, gait_speed, acceleration)
		
		var direction := -transform.basis.z.normalized() * speed
		velocity.x = direction.x
		velocity.z = direction.z
	
	move_and_slide()
	
	# Rotate and move camera
	spring_arm.rotation_degrees.x = camera_rotation.x * CAMERA_SPEED
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
	pivot.rotation_degrees.y = camera_rotation.y * CAMERA_SPEED
	pivot.global_position.x = global_position.x
	pivot.global_position.z = global_position.z
