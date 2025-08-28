extends Station

@export var wheat_consumed: int = 1
@export var wheat_amount: int = 0

func _process(delta: float) -> void:
	if wheat_amount > 0:
		$Sprite2D.visible = true
	else:
		$Sprite2D.visible = false

func _on_crush_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
		
	if GameManager.inventory != GameManager.Items.WHEAT:
		return
	
	GameManager.inventory = GameManager.Items.EMPTY
	GameManager.is_busy = true
	$StationProgressRadial.visible = true
	var winter_multiplier = 1
	if GameManager.winter_intensity > 0:
		winter_multiplier = 1.5
	$Timer.start($Timer.wait_time * winter_multiplier)
	
func _on_timer_timeout() -> void:
	GameManager.gain_flour()
	GameManager.is_busy = false

func add_wheat(wheat_to_add: int) -> void:
	wheat_amount += wheat_to_add
