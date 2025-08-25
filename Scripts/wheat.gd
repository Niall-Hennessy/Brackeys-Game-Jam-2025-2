extends Node2D

func _on_proximity_trigger_body_entered(body: Node2D) -> void:
	$HarvestButton.visible = true

func _on_proximity_trigger_body_exited(body: Node2D) -> void:
	$HarvestButton.visible = false

func _on_harvest_button_pressed() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	GameManager.gain_wheat(3)
