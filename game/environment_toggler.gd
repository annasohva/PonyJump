extends Node3D


@export var tree_parents: Array[Node3D]
@export var foliage_parents: Array[Node3D]
@export var nature_prop_parents: Array[Node3D]

var show_trees: bool = true:
	get:
		return show_trees
	set(value):
		for tree_parent in tree_parents:
			tree_parent.visible = value
		show_trees = value

var show_foliage: bool = true:
	get:
		return show_foliage
	set(value):
		for foliage_parent in foliage_parents:
			foliage_parent.visible = value
		show_foliage = value

var show_nature_props: bool = true:
	get:
		return show_nature_props
	set(value):
		for nature_prop_parent in nature_prop_parents:
			nature_prop_parent.visible = value
		show_nature_props = value


func _enter_tree() -> void:
	EventSystem.SET_toggle_trees.connect(func(toggle: bool): show_trees = toggle)
	EventSystem.SET_toggle_foliage.connect(func(toggle: bool): show_foliage = toggle)
	EventSystem.SET_toggle_nature_props.connect(func(toggle: bool): show_nature_props = toggle)


func _ready() -> void:
	show_trees = SettingsManager.Settings.get(SettingsManager.TREES_KEY, true)
	show_foliage = SettingsManager.Settings.get(SettingsManager.FOLIAGE_KEY, true)
	show_nature_props = SettingsManager.Settings.get(SettingsManager.NATURE_PROPS_KEY, true)
