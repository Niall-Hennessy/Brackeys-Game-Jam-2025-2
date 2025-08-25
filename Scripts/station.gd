class_name Station
extends Node

func _physics_process(delta: float) -> void:
	if $Timer.time_left != 0:
		$StationProgressRadial.value = (100 - ($Timer.time_left/$Timer.wait_time) * 100)
	else:
		$StationProgressRadial.visible = false

func _on_proximity_trigger_body_entered(body: Node2D) -> void:
	$ActionButton.visible = true

func _on_proximity_trigger_body_exited(body: Node2D) -> void:
	$ActionButton.visible = false
