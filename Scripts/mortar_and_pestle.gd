extends Node2D

func _on_proximity_trigger_body_entered(body: Node2D) -> void:
	$CrushButton.visible = true

func _on_proximity_trigger_body_exited(body: Node2D) -> void:
	$CrushButton.visible = false

func _on_crush_button_pressed() -> void:
	$Timer.start()
	
func _on_timer_timeout() -> void:
	GameManager.gain_flour(1)
