extends Node

@export var biscuits: int = 0
@export var wheat: int = 0
@export var flour: int = 0
@export var water: int = 0
@export var dough: int = 0

enum Items {EMPTY, WHEAT, FLOUR, WATER, DOUGH}
@export var inventory: int = Items.EMPTY

@export var is_busy: bool = false

@export var turn: int = 1
@export var player_distance: int = 1000
@export var winter_distance: int = 0

@export var distance_per_biscuit: int = 100

var rng = RandomNumberGenerator.new()

var my_array = [100, 200, 300, 400, 500]
var weights = PackedFloat32Array([0.5, 1, 2, 1.5, 1]) #https://docs.godotengine.org/en/4.4/classes/class_randomnumbergenerator.html
	
func initialise_vars() -> void:
	biscuits = 0
	wheat = 0
	flour = 0
	water = 0
	dough = 0
	inventory = Items.EMPTY
	turn = 1
	player_distance = 1000
	winter_distance = 0


func gain_biscuit(num_biscuits: int) -> void:		
	biscuits += num_biscuits
	dough -= num_biscuits

func gain_dough(num_dough: int) -> void:
	flour -= num_dough
	water -= num_dough
	dough += num_dough
	if inventory == Items.DOUGH:
		inventory = Items.WHEAT
	print(inventory)

func gain_water(num_water: int) -> void:
	water += num_water
	if inventory == Items.EMPTY:
		inventory = Items.WATER
	print(inventory)
	
func gain_wheat(num_wheat: int) -> void:
	wheat += num_wheat
	if inventory == Items.EMPTY:
		inventory = Items.WHEAT
	print(inventory)

func gain_flour(num_flour: int) -> void:
	wheat -= num_flour
	flour += num_flour
	if inventory == Items.EMPTY:
		inventory = Items.FLOUR
	print(inventory)

func next_turn(consume_num_biscuits: int) -> void:
	if biscuits < consume_num_biscuits:
		return
	
	biscuits -= consume_num_biscuits
	player_distance += consume_num_biscuits * distance_per_biscuit
	winter_distance += my_array[rng.rand_weighted(weights)]
	if winter_distance > player_distance:
		get_tree().change_scene_to_file("res://Scenes/Screens/game_over_screen.tscn")
	else:
		turn += 1
