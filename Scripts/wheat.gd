extends Station

func _on_harvest_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
	
	GameManager.is_busy = true
	$StationProgressRadial.visible = true
	$Timer.start()

func _on_timer_timeout() -> void:
	GameManager.gain_wheat(3)
	GameManager.is_busy = false
