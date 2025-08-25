extends Node2D

func _on_proximity_trigger_body_entered(body: Node2D) -> void:
	$MixingButton.visible = true

func _on_proximity_trigger_body_exited(body: Node2D) -> void:
	$MixingButton.visible = false

func _on_button_pressed() -> void:
	GameManager.gain_dough(3)
