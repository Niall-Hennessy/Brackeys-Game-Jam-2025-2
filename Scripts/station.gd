class_name Station
extends Node

var is_player_in_range: bool = false

func _physics_process(delta: float) -> void:
	if $Timer.time_left != 0:
		$StationProgressRadial.value = (100 - ($Timer.time_left/$Timer.wait_time) * 100)
	else:
		$StationProgressRadial.visible = false

func _on_proximity_trigger_body_entered(body: Node2D) -> void:
	$ActionButton.visible = true
	is_player_in_range = true

func _on_proximity_trigger_body_exited(body: Node2D) -> void:
	$ActionButton.visible = false
	is_player_in_range = false
	
func _input(event):
	if Input.is_action_just_pressed("interact") and is_player_in_range:
		print(name)#Add code here to communicate between Player and Stations
