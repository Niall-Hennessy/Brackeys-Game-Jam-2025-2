extends Station

func _on_harvest_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
	
	$StationProgressRadial.visible = true
	$Timer.start()

func _on_timer_timeout() -> void:
	GameManager.gain_wheat(3)
