extends Station

func _on_harvest_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
	
	if GameManager.inventory != GameManager.Items.EMPTY:
		return
	
	GameManager.is_busy = true
	$StationProgressRadial.visible = true
	var winter_multiplier = 1
	if GameManager.winter_intensity > 0:
		winter_multiplier = 1.5
	$Timer.start($Timer.wait_time * winter_multiplier)

func _on_timer_timeout() -> void:
	GameManager.gain_wheat()
	GameManager.is_busy = false
