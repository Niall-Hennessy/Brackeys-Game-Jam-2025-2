extends Button

func _on_pressed() -> void:
	GameManager.turn_ended.emit()
