extends Control

func _ready() -> void:
	if GameManager.camp_timer_storage:
		$CampTimer.start(GameManager.camp_timer_storage)

func _physics_process(delta: float) -> void:
	$WinterClockProgressRadial.value = snapped($CampTimer.time_left, 0.01)

func _process(delta: float) -> void:
	$GameManagerLabel.text = "Inventory: " + str(GameManager.inventory_string()) + "\nBiscuits: " + str(GameManager.biscuits)
	$BiscuitLabel.text = "x" + str(GameManager.biscuits)
	#$TimeRemainingLabel.text = "Time Remaining:\n" + str(snapped($CampTimer.time_left, 0.01))
	%PlayerProgressBar.value = GameManager.player_distance/100
	%WinterProgressBar.value = GameManager.winter_distance/100
	match GameManager.inventory:
		0:
			$ItemBox.texture = load("res://Assets/ItemBoxes/Item_Background_Temp.png")
		1:
			$ItemBox.texture = load("res://Assets/ItemBoxes/Wheat_Item_Background_Temp.png")
		2:
			$ItemBox.texture = load("res://Assets/ItemBoxes/Flour_Item_Background_Temp.png")
		3:
			$ItemBox.texture = load("res://Assets/ItemBoxes/Water_Item_Background_Temp.png")
		4:
			$ItemBox.texture = load("res://Assets/ItemBoxes/Dough_Item_Background_Temp.png")
			
	get_parent().get_node("SnowGenerator").emitting = GameManager.winter_intensity > 0 # only emit snow over intensity = 1
	

func _on_discard_button_pressed() -> void:
	GameManager.discard_item_sig.emit()

func _on_world_map_button_pressed() -> void:
	GameManager.camp_timer_storage = $CampTimer.time_left
	get_tree().change_scene_to_file("res://Scenes/WorldMap/world_map.tscn")

func _on_camp_timer_timeout() -> void:
	GameManager.camp_timer_storage = 0
	GameManager.next_turn()
	$CampTimer.start(GameManager.timer_duration_seconds)
