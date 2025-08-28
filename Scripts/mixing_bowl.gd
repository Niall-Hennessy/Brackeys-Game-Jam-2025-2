extends Station

@export var flour_consumed: int = 1
@export var water_consumed: int = 1
@export var flour_amount: int = 0
@export var water_amount: int = 0
	
@export var has_water: bool = false
@export var has_flour: bool = false

	
func _process(delta: float) -> void:
	if has_flour:
		$FlourItemSprite.visible = true
	else:
		$FlourItemSprite.visible = false
	
	if has_water:
		$WaterItemSprite.visible = true
	else:
		$WaterItemSprite.visible = false
	
func _on_mixing_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
	
	if GameManager.inventory == GameManager.Items.FLOUR and !has_flour:
		GameManager.inventory = GameManager.Items.EMPTY
		has_flour = true
		
	if GameManager.inventory == GameManager.Items.WATER and !has_water:
		GameManager.inventory = GameManager.Items.EMPTY
		has_water = true
	
	if has_water and has_flour:
		GameManager.is_busy = true
		$StationProgressRadial.visible = true
		var winter_multiplier = 1
		if GameManager.winter_intensity > 0:
			winter_multiplier = 1.5
		$Timer.start($Timer.wait_time * winter_multiplier)

func _on_timer_timeout() -> void:
	GameManager.gain_dough()
	GameManager.is_busy = false
	has_water = false
	has_flour = false

func add_flour(flour_to_add: int) -> void:
	flour_amount += flour_to_add
	
func add_water(water_to_add: int) -> void:
	water_amount += water_to_add
