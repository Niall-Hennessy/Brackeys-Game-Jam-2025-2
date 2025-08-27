class_name MapGenerator
extends Node
#https://www.youtube.com/watch?v=7HYu7QXBuCY

@export var grass_camp_weight = 11
@export var desert_camp_weight = 7
@export var rocky_camp_weight = 8

const X_Dist := 30
const Y_Dist := 25
const PLACEMENT_RANDOMNESS := 5
const FLOORS := 15
const MAP_HEIGHT := 4
const PATHS := 3

var map_data: Array[Array]

var rng = RandomNumberGenerator.new()
var camp_biomes_array = [Camp.Biome.GRASS, Camp.Biome.ROCKY, Camp.Biome.DESERT]
var weights = PackedFloat32Array([grass_camp_weight, desert_camp_weight, rocky_camp_weight])

func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points: Array[int]= [2,2,2,2]#_get_random_starting_points()	
	
	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = _setup_connection(i, current_j)
			
	_setup_camp_biomes()
	
	return map_data

func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for i in FLOORS:
		var adjacent_camps: Array[Camp] = []
	
		for j in MAP_HEIGHT:
			var current_camp := Camp.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_camp.position = Vector2(i * X_Dist, j * -Y_Dist) + offset
			current_camp.column = i
			current_camp.row = j
			current_camp.next_camps = []
			
			adjacent_camps.append(current_camp)
	
		result.append(adjacent_camps)
	return result

func _setup_connection(i: int, j: int) -> int:
	var next_camp: Camp
	var current_camp := map_data[i][j] as Camp
	
	while not next_camp or _would_cross_existing_path(i, j, next_camp):
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_HEIGHT - 1)
		next_camp = map_data[i + 1][random_j]
		
	current_camp.next_camps.append(next_camp)
	
	return next_camp.row
	
func _would_cross_existing_path(i: int, j: int, camp: Camp) -> bool:
	var left_neighbour: Camp
	var right_neighbour: Camp
	
	if j > 0:
		left_neighbour = map_data[i][j-1]
	if j < MAP_HEIGHT - 1:
		right_neighbour = map_data[i][j + 1]
		
	if right_neighbour and camp.row > j:
		for next_camp: Camp in right_neighbour.next_camps:
			if next_camp.row < camp.row:
				return true
				
	if left_neighbour and camp.row < j:
		for next_camp: Camp in left_neighbour.next_camps:
			if next_camp.row > camp.row:
				return true
	
	return false

func _setup_camp_biomes() -> void:
	for camp: Camp in map_data[0]:
		if camp.next_camps.size() > 0:
			camp.biome = Camp.Biome.GRASS

	for current_floor in map_data:
		for camp: Camp in current_floor:
			for next_camp: Camp in camp.next_camps:
				if next_camp.biome == Camp.Biome.UNASSIGNED:
					next_camp.biome = camp_biomes_array[rng.rand_weighted(weights)]
