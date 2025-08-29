extends Control

func _ready() -> void:
	if GameManager.camp_timer_storage:
		$CampTimer.start(GameManager.camp_timer_storage)
		print(GameManager.camp_timer_storage)

func _process(delta: float) -> void:
	$GameManagerLabel.text = "Inventory: " + str(GameManager.inventory_string()) + "\nBiscuits: " + str(GameManager.biscuits) + "\nTurn: " + str(GameManager.turn) + "\nPlayer Distance: " + str(GameManager.player_distance) + "\nWinter Distance: " + str(GameManager.winter_distance)
	$TimeRemainingLabel.text = "Time Remaining:\n" + str(snapped($CampTimer.time_left, 0.01))

func _on_end_turn_button_pressed() -> void:
	$CampTimer.start(60)

func _on_discard_button_pressed() -> void:
	GameManager.discard_item_sig.emit()

func _on_world_map_button_pressed() -> void:
	GameManager.camp_timer_storage = $CampTimer.time_left
	get_tree().change_scene_to_file("res://Scenes/WorldMap/world_map.tscn")
