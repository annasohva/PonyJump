extends Control


func _enter_tree() -> void:
	EventSystem.LEV_level_changed.connect(queue_free)
