extends Station

@export var dough_consumed: int = 1

func _on_biscuit_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
	
	if GameManager.dough < dough_consumed:
		return
	
	$StationProgressRadial.visible = true
	$Timer.start()
	
func _on_timer_timeout() -> void:
	GameManager.gain_biscuit(3)
