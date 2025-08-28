extends Station

var quantities = {"Plains":5, "Arid":5, "Mountain":5, "Forest":5, "River":5}
var quantity = 5

func _ready() -> void:
	var camp = GameManager.get_current_camp()
	if camp != "":
		quantity = quantities[GameManager.get_current_camp()]

func _on_button_pressed() -> void:
	if $Timer.time_left != 0:
		return
		
	if GameManager.inventory != GameManager.Items.EMPTY:
		return
	
	GameManager.is_busy = true
	$StationProgressRadial.visible = true
	var winter_multiplier = 1
	if GameManager.winter_intensity > 0:
		winter_multiplier = 1.5
	$Timer.start($Timer.wait_time * winter_multiplier)

func _on_timer_timeout() -> void:
	GameManager.gain_water()
	GameManager.is_busy = false
	quantity -= 1
	if quantity < 1:
		# destroy this object
		queue_free()
