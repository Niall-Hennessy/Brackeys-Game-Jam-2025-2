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
	
	if GameManager.inventory != GameManager.Items.DOUGH:
		return
	
	GameManager.inventory = GameManager.Items.EMPTY
	$StationProgressRadial.visible = true
	var winter_multiplier = 1
	if GameManager.winter_intensity > 0:
		winter_multiplier = 1.5
	$Timer.start($Timer.wait_time * winter_multiplier)
	
func _on_timer_timeout() -> void:
	GameManager.gain_biscuit(1)
	dough_amount = 0

func add_dough(dough_to_add: int) -> void:
	dough_amount += dough_to_add
