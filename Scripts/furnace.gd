extends Station

@export var dough_consumed: int = 1
@export var dough_amount: int = 0

func _process(delta: float) -> void:
	if dough_amount > 0:
		$Sprite2D.visible = true
	else:
		$Sprite2D.visible = false

func _on_biscuit_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
	
	if GameManager.dough < dough_consumed:
		return
	
	$StationProgressRadial.visible = true
	$Timer.start()
	
func _on_timer_timeout() -> void:
	GameManager.gain_biscuit(1)

func add_dough(dough_to_add: int) -> void:
	dough_amount += dough_to_add
