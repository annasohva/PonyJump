extends Node


func _enter_tree() -> void:
	EventSystem.LEV_change_level.connect(load_level)


func _ready() -> void:
	load_level(LevelReference.Keys.JumpingArena1)


func load_level(level_key: LevelReference.Keys):
	for level in get_children():
		level.queue_free()
	
	add_child(LevelReference.GetLevel(level_key))
