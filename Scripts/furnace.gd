extends Node2D

func _on_proximity_trigger_body_entered(body: Node2D) -> void:
	print("Test")
	$BiscuitButton.visible = true

func _on_proximity_trigger_body_exited(body: Node2D) -> void:
	$BiscuitButton.visible = false

func _on_button_pressed() -> void:
	print("Made 5 Biscuits")
