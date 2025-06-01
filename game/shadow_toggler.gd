extends DirectionalLight3D


func _enter_tree() -> void:
	EventSystem.SET_toggle_shadows.connect(func(toggle: bool): shadow_enabled = toggle)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shadow_enabled = SettingsManager.Settings.get(SettingsManager.SHADOWS_KEY, true)
