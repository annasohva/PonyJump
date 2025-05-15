class_name Pole
extends RigidBody3D


func drop(direction: Vector3):
	freeze = false
	apply_central_impulse(direction*2)
