extends Station

@export var wheat_consumed: int = 1

func _on_crush_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
		
	if GameManager.wheat < wheat_consumed:
		return
	
	$StationProgressRadial.visible = true
	$Timer.start()
	
func _on_timer_timeout() -> void:
	GameManager.gain_flour(1)
