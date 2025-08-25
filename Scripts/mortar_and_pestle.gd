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
		
	if GameManager.wheat < wheat_consumed:
		return
	
	$StationProgressRadial.visible = true
	$Timer.start()
	
func _on_timer_timeout() -> void:
	GameManager.gain_flour(1)

func add_wheat(wheat_to_add: int) -> void:
	wheat_amount += wheat_to_add
