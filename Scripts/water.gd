extends Station

func _on_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
		
	if GameManager.inventory != GameManager.Items.EMPTY:
		return
	
	GameManager.is_busy = true
	$StationProgressRadial.visible = true
	$Timer.start()

func _on_timer_timeout() -> void:
	GameManager.gain_water()
	GameManager.is_busy = false
