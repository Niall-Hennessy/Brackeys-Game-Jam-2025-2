extends Control

func _process(delta: float) -> void:
	$GameManagerLabel.text = "Biscuits: " + str(GameManager.biscuits) + "\nWheat: " + str(GameManager.wheat) + "\nWater: " + str(GameManager.water) + "\nFlour: " + str(GameManager.flour) +  "\nDough: " + str(GameManager.dough) + "\nTurn: " + str(GameManager.turn) + "\nPlayer Distance: " + str(GameManager.player_distance) + "\nWinter Distance: " + str(GameManager.winter_distance)

func _on_end_turn_button_pressed() -> void:
	GameManager.next_turn(int($LineEdit.text))
