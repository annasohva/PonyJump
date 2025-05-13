class_name Pole
extends RigidBody3D


func fall(direction: Vector3):
	freeze = false
	apply_central_impulse(direction)
	set_collision_layer_value(1, false)
