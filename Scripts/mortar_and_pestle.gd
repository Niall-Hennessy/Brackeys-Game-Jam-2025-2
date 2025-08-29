extends Station

@export var wheat_consumed: int = 1
@export var wheat_amount: int = 0

@export var has_flour: bool = false

func _process(delta: float) -> void:
	if has_flour:
		$Sprite2D.visible = true
		$ActionButton.text = "Collect"
	else:
		$Sprite2D.visible = false
		$ActionButton.text = "Crush"

func _on_crush_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
		
	if has_flour:
		GameManager.gain_flour()
		has_flour = false
		return
		
	if GameManager.inventory != GameManager.Items.WHEAT:
		return
	
	GameManager.inventory = GameManager.Items.EMPTY
	$StationProgressRadial.visible = true
	var winter_multiplier = 1
	if GameManager.winter_intensity > 0:
		winter_multiplier = 1.5
	$Timer.start($Timer.wait_time * winter_multiplier)
	
func _on_timer_timeout() -> void:
	has_flour = true

func add_wheat(wheat_to_add: int) -> void:
	wheat_amount += wheat_to_add
