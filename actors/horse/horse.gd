extends CharacterBody3D


enum Gaits
{
	Back = -1,
	Stop = 0,
	Walk = 1,
	Trot = 2,
	Canter = 3,
	Gallop = 4
}

const TURNING_SPEED = 2
const JUMP_VELOCITY = 4.5

@onready var spring_arm: SpringArm3D = $SpringArm3D

var camera_rotation: Vector2 = Vector2.ZERO
var current_gait: Gaits = Gaits.Stop


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
	
	if event.is_action_pressed("backward"):
		current_gait = clamp(current_gait - 1, Gaits.Back, Gaits.Gallop)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Rotate and move camera
	spring_arm.rotation_degrees.x = camera_rotation.x
	spring_arm.rotation_degrees.y = camera_rotation.y
	spring_arm.global_position = global_position
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var speed := 0
	match current_gait:
		Gaits.Back:
			speed = 3
		Gaits.Walk:
			speed = 5
		Gaits.Trot:
			speed = 10
		Gaits.Canter:
			speed = 15
		Gaits.Gallop:
			speed = 20
	
	# Get the turn direction and handle the movement/deceleration
	var turn_dir := Input.get_axis("left", "right")
	
	speed = -speed if current_gait == Gaits.Back else speed
	velocity.x = speed
	
	if turn_dir:
		velocity.z = turn_dir * TURNING_SPEED
		rotation_degrees.y -= turn_dir * TURNING_SPEED
	else:
		velocity.z = move_toward(velocity.z, 0, TURNING_SPEED)
		
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	move_and_slide()
