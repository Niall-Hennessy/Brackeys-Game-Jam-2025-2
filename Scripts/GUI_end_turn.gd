extends Control

#@onready var end_turn_menu = $PauseMenu

func _init() -> void:
	self.hide()

func _on_end_turn_button_pressed() -> void:
	self.show()
	# set the slider's max value to the number of biscuits you have
	$NumberOfBiscuitsSlider.max_value = GameManager.biscuits
	$NumberOfBiscuitsSlider.tick_count = GameManager.biscuits
	get_tree().paused = true
	

func _on_advance_button_pressed() -> void:
	var textBox = $NumberOfBiscuitsLabel
	var num_biscuits = int(textBox.text)
	self.hide()
	get_tree().paused = false
	GameManager.next_turn(num_biscuits)


func _on_number_of_biscuits_slider_value_changed(value: float) -> void:
	$NumberOfBiscuitsLabel.text = str(int(value))
