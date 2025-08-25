extends Station

@export var flour_consumed: int = 1
@export var water_consumed: int = 1
@export var flour_amount: int = 0
@export var water_amount: int = 0

func _process(delta: float) -> void:
	if flour_amount > 0:
		$Sprite2D.visible = true
	else:
		$Sprite2D.visible = false
	
func _on_mixing_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
	
	if GameManager.flour < flour_consumed or GameManager.water < water_consumed:
		return
	
	$StationProgressRadial.visible = true
	$Timer.start()
	
func _on_timer_timeout() -> void:
	GameManager.gain_dough(1)
