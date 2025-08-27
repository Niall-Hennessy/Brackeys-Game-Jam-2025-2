extends Control


func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().paused = true
		show()

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()
