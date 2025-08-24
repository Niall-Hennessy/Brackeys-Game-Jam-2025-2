extends Label

func _process(delta: float) -> void:
	text = "Biscuits: " + str(GameManager.biscuits) + "\nTurn: " + str(GameManager.turn)
