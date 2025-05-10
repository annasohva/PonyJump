class_name Horse extends CharacterBody3D


@onready var spring_arm: SpringArm3D = $Pivot/SpringArm3D
@onready var pivot: Node3D = $Pivot

var gait_speed: int = 0
var speed: float = 0
var acceleration: float = .5

var current_gait: Gaits = Gaits.Stop
var jump_curve: Curve3D = Curve3D.new()

var timer: float = 0

const TURNING_SPEED := 3
const CAMERA_SPEED := 0.8
const JUMP_VELOCITY := 4.5

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


func calculate_jump_curve():
	jump_curve.clear_points()
	
	if jump_landing_pos == Vector3.ZERO: return
	
	#var target_pos = jump_landing_pos if jump_landing_pos != Vector3.ZERO else global_position + -transform.basis.z.normalized() * 3
	var jump_height_pos = global_position.lerp(jump_landing_pos, 0.5)
	jump_height_pos.y += 2.5
	
	jump_curve.add_point(global_position)
	jump_curve.add_point(jump_height_pos, transform.basis.z.normalized(), -transform.basis.z.normalized())
	jump_curve.add_point(jump_landing_pos)


func _physics_process(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() && current_gait > Gaits.Walk:
		calculate_jump_curve()
	
	if (jump_curve.point_count != 0):
		timer += delta * 2
		global_position = jump_curve.sample_baked(timer * jump_curve.get_baked_length())
		
		if (global_position - jump_curve.get_point_position(jump_curve.point_count-1)).length() < 0.1:
			timer = 0
			jump_curve.clear_points()
	
	# Add the gravity.
	if not is_on_floor() && jump_curve.point_count == 0:
		velocity += get_gravity() * delta
	
	#Handle movement
	if jump_curve.point_count == 0:
		var turn_dir := Input.get_axis("left", "right")
		if turn_dir:
			rotate_y(-deg_to_rad(turn_dir * TURNING_SPEED))
		
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
	if is_on_floor(): pivot.global_position.y = global_position.y + 2
