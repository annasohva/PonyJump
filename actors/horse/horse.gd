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

const TURNING_SPEED := 3
const CAMERA_SPEED := 0.8
const JUMP_VELOCITY := 4.5

@onready var spring_arm: SpringArm3D = $Pivot/SpringArm3D
@onready var pivot: Node3D = $Pivot

var camera_rotation: Vector2 = Vector2.ZERO

var speed := 0
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
		adjust_speed()
	
	if event.is_action_pressed("backward"):
		current_gait = clamp(current_gait - 1, Gaits.Back, Gaits.Gallop)
		adjust_speed()


func adjust_speed():
	match current_gait:
		Gaits.Back:
			speed = -3
		Gaits.Stop:
			speed = 0
		Gaits.Walk:
			speed = 5
		Gaits.Trot:
			speed = 10
		Gaits.Canter:
			speed = 15
		Gaits.Gallop:
			speed = 20


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Rotate and move camera
	spring_arm.rotation_degrees.x = camera_rotation.x * CAMERA_SPEED
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
	pivot.rotation_degrees.y = camera_rotation.y * CAMERA_SPEED
	pivot.global_position.x = global_position.x
	pivot.global_position.z = global_position.z
	if is_on_floor(): pivot.global_position.y = global_position.y + 2
	
	#Handle movement
	var turn_dir := Input.get_axis("left", "right")
	if turn_dir:
		rotate_y(-deg_to_rad(turn_dir * TURNING_SPEED))
	
	var direction := -transform.basis.z.normalized() * speed
	velocity.x = direction.x
	velocity.z = direction.z
	
	move_and_slide()
