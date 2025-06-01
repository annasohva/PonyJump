extends Control


@onready var gameplay_options: Control = $BackgroundPanel/GameplayOptions
@onready var audio_options: Control = $BackgroundPanel/AudioOptions
@onready var graphics_options: Control = $BackgroundPanel/GraphicsOptions


enum TabKeys
{
	Gameplay,
	Audio,
	Graphics
}


func _on_close_button_pressed() -> void:
	queue_free()


func _on_tab_bar_tab_changed(tab: int) -> void:
	gameplay_options.visible = tab == TabKeys.Gameplay
	audio_options.visible = tab == TabKeys.Audio
	graphics_options.visible = tab == TabKeys.Graphics
