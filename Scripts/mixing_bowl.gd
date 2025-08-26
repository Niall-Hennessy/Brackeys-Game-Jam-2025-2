extends Station

@export var flour_consumed: int = 1
@export var water_consumed: int = 1
@export var flour_amount: int = 0
@export var water_amount: int = 0
	
func _process(delta: float) -> void:
	if flour_amount > 0:
		$FlourItemSprite.visible = true
	else:
		$FlourItemSprite.visible = false
	
	if water_amount > 0:
		$WaterItemSprite.visible = true
	else:
		$WaterItemSprite.visible = false
	
func _on_mixing_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
	
	if GameManager.flour < flour_consumed or GameManager.water < water_consumed:
		return
		
	GameManager.is_busy = true
	$StationProgressRadial.visible = true
	$Timer.start()
	
func _on_timer_timeout() -> void:
	GameManager.gain_dough(1)
	GameManager.is_busy = false

func add_flour(flour_to_add: int) -> void:
	flour_amount += flour_to_add
	
func add_water(water_to_add: int) -> void:
	water_amount += water_to_add
