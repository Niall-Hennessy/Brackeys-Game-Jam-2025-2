extends Control

func _process(delta: float) -> void:
	$GameManagerLabel.text = "Biscuits: " + str(GameManager.biscuits) + "\nWater: " + str(GameManager.water) + "\nDough: " + str(GameManager.dough) + "\nTurn: " + str(GameManager.turn) + "\nPlayer Distance: " + str(GameManager.player_distance) + "\nWinter Distance: " + str(GameManager.winter_distance)

func _on_end_turn_button_pressed() -> void:
	GameManager.next_turn(int($LineEdit.text))
