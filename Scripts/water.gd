extends Station

func _on_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
	
	GameManager.is_busy = true
	$StationProgressRadial.visible = true
	$Timer.start()

func _on_timer_timeout() -> void:
	GameManager.gain_water(1)
	GameManager.is_busy = false
