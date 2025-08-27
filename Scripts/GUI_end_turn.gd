extends Control

#@onready var end_turn_menu = $PauseMenu

func _init() -> void:
	self.hide()

func _on_end_turn_button_pressed() -> void:
	self.show()
	

func _on_advance_button_pressed() -> void:
	var textBox = $NumberOfBiscuits
	var num_biscuits = int(textBox.text)
	self.hide()
	GameManager.next_turn(num_biscuits)
