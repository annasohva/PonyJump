extends Node


func _enter_tree() -> void:
	EventSystem.UI_open_menu.connect(open_menu)


func open_menu(key: UiReference.Keys):
	add_child(UiReference.GetMenu(key))
