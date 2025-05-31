extends Node

var hud: Control

func _enter_tree() -> void:
	EventSystem.UI_open_menu.connect(open_menu)
	EventSystem.UI_toggle_hud.connect(toggle_hud)


func open_menu(key: UiReference.Keys):
	var menu = UiReference.GetMenu(key)
	add_child(menu)
	
	if key == UiReference.Keys.PlayerHud:
		hud = menu


func toggle_hud(show: bool):
	if hud != null:
		hud.visible = show
