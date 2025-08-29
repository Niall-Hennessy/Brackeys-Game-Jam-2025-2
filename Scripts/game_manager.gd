extends Node

@export var biscuits: int = 0

enum Items {EMPTY, WHEAT, FLOUR, WATER, DOUGH}
@export var inventory: int = Items.EMPTY

@export var turn: int = 1
@export var player_distance: int = 1000
@export var winter_distance: int = 0
@export var winter_intensity = 0

@export var distance_per_biscuit: int = 100

@export var camp_timer : Timer
var timer_duration_seconds: float = 60

var rng = RandomNumberGenerator.new()

var my_array = [100, 200, 300, 400, 500]
var weights = PackedFloat32Array([0.5, 1, 2, 1.5, 1]) #https://docs.godotengine.org/en/4.4/classes/class_randomnumbergenerator.html

var map_data: Array[Array]
var player_world_map_position: Vector2
var camps_traversed: int
var world_map_selected_camp: Camp
var world_map_current_camp: Camp
var travel_progress: int
var biscuits_per_travel: int

var camp_time: float = 60
var camp_timer_storage: float

signal discard_item_sig
signal gained_item_sig

func _ready() -> void:
	discard_item_sig.connect(discard_item)	

func initialise_vars() -> void:
	biscuits = 10
	inventory = Items.EMPTY
	turn = 1
	player_distance = 1000
	winter_distance = 0
	# camp timer starts automatically upon entering the scene
	

func inventory_string() -> String:
	match inventory:
		0:
			return "Empty"
		1:
			return "Wheat"
		2:
			return "Flour"
		3:
			return "Water"
		4:
			return "Dough"
		_:
			return "you've met with a terrible fate haven't you" 

func gain_biscuit(num_biscuits: int) -> void:		
	biscuits += num_biscuits

func gain_dough() -> void:
	if inventory == Items.EMPTY:
		inventory = Items.DOUGH

func gain_water() -> void:
	if inventory == Items.EMPTY:
		inventory = Items.WATER
	
func gain_wheat() -> void:
	if inventory == Items.EMPTY:
		inventory = Items.WHEAT

func gain_flour() -> void:
	if inventory == Items.EMPTY:
		inventory = Items.FLOUR
	
func discard_item() -> void:
	inventory = Items.EMPTY

func next_turn() -> void:
	print("winter advanced cause a turn ended\nwinter distance:" + str(GameManager.winter_distance))
	winter_distance += my_array[rng.rand_weighted(weights)]
	if winter_distance > player_distance:
		get_tree().change_scene_to_file("res://Scenes/Screens/game_over_screen.tscn")
	else:
		turn += 1
		
		# calculate winter intensity
		var gap = player_distance - winter_distance
		if gap > 800:
			winter_intensity = 0 # default
		elif gap > 400:
			winter_intensity = 1 # small graphical change, increase station times
		else:
			winter_intensity = 2 # noticeable graphical change, add obstacles

func get_current_camp() -> String :
	if world_map_current_camp == null:
		return ""

	match world_map_current_camp.biome:
		Camp.Biome.PLAINS:
			return "Plains"
		Camp.Biome.ARID:
			return "Arid"
		Camp.Biome.MOUNTAIN:
			return "Mountain"
		Camp.Biome.RIVER:
			return "River"
		Camp.Biome.FOREST:
			return "Forest"
		_:
			return ""
