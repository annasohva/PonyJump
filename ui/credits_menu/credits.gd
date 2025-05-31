extends Control


# Using text edit to display the credits text so player can copy the links
@export var credits_text_edit: TextEdit


func _enter_tree() -> void:
	# Loading credits from the text file
	var credits_file = FileAccess.open("res://CREDITS.txt", FileAccess.READ)
	credits_text_edit.text = credits_file.get_as_text()


func _on_close_button_pressed() -> void:
	queue_free()
