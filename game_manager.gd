extends Node

@export var biscuits: int = 0
@export var wheat: int = 0
@export var flour: int = 0
@export var water: int = 0
@export var dough: int = 0

@export var turn: int = 1
@export var player_distance: int = 1000
@export var winter_distance: int = 0

var rng = RandomNumberGenerator.new()

var my_array = [100, 200, 300, 400, 500]
var weights = PackedFloat32Array([0.5, 1, 2, 1.5, 1]) #https://docs.godotengine.org/en/4.4/classes/class_randomnumbergenerator.html
	
func gain_biscuit(num_biscuits: int) -> void:
	if num_biscuits > dough:
		return
		
	biscuits += num_biscuits
	dough -= num_biscuits

func gain_dough(num_dough: int) -> void:
	dough += num_dough

func next_turn(consume_num_biscuits: int) -> void:
	if biscuits < consume_num_biscuits:
		return
	
	biscuits -= consume_num_biscuits
	player_distance += consume_num_biscuits * 100
	winter_distance += my_array[rng.rand_weighted(weights)]
	turn += 1
