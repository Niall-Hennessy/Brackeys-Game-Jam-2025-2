extends Node

@export var biscuits: int = 0
@export var turn: int = 1

signal biscuit_gained
signal turn_ended

func _ready() -> void:
	GameManager.biscuit_gained.connect(gain_biscuit)
	GameManager.turn_ended.connect(next_turn)
	
func gain_biscuit() -> void:
	biscuits += 1

func next_turn() -> void:
	biscuits -= 3
	turn += 1
