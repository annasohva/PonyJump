class_name Pole
extends RigidBody3D

var is_dropped: bool = false


func drop(direction: Vector3):
	freeze = false
	apply_central_impulse(direction*2)


func crash(direction: Vector3):
	freeze = false
	apply_central_impulse(direction * transform * 30 + Vector3(randf_range(0,50), randf_range(0,50), randf_range(0,50)))
