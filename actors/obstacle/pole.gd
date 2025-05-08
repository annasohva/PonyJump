class_name Pole
extends RigidBody3D


func fall(direction: Vector3):
	apply_central_impulse(direction)
