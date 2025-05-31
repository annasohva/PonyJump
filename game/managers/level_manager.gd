extends Node


func _enter_tree() -> void:
	EventSystem.LEV_change_level.connect(load_level)


func _ready() -> void:
	load_level(LevelReference.Keys.MainMenu)


func load_level(level_key: LevelReference.Keys):
	EventSystem.LEV_level_changed.emit()
	
	for level in get_children():
		level.queue_free()
	
	add_child(LevelReference.GetLevel(level_key))
