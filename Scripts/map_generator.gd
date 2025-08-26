class_name MapGenerator
extends Node
#https://www.youtube.com/watch?v=7HYu7QXBuCY

const X_Dist := 30
const Y_Dist := 25
const PLACEMENT_RANDOMNESS := 5
const FLOORS := 15
const MAP_WIDTH := 7
const PATHS := 6
const GRASS_ROOM_WEIGHT := 10
const DESERT_ROOM_WEIGHT := 3
const ROCKY_ROOM_WEIGHT := 4

var random_camp_biome_weights = {
	Camp.Biome.GRASS: 0.0,
	Camp.Biome.DESERT: 0.0,
	Camp.Biome.ROCKY: 0.0	
}

var random_camp_biome_total_weight := 0
var map_data: Array[Array]

func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_random_starting_points()	
	
	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = _setup_connection(i, current_j)
	
	_setup_random_camp_weights()
	_setup_camp_biomes()
	
	return map_data

func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for i in FLOORS:
		var adjacent_camps: Array[Camp] = []
	
		for j in MAP_WIDTH:
			var current_camp := Camp.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_camp.position = Vector2(j * X_Dist, i * -Y_Dist) + offset
			current_camp.row = i
			current_camp.column = j
			current_camp.next_camps = []
			
			adjacent_camps.append(current_camp)
	
		result.append(adjacent_camps)
	return result

func _get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0
	
	while unique_points < 2:
		unique_points = 0
		y_coordinates = []
		
		for i in PATHS:
			var starting_point := randi_range(0, MAP_WIDTH - 1)
			if not y_coordinates.has(starting_point):
				unique_points += 1
			
			y_coordinates.append(starting_point)
	
	return y_coordinates

func _setup_connection(i: int, j: int) -> int:
	var next_camp: Camp
	var current_camp := map_data[i][j] as Camp
	
	while not next_camp or _would_cross_existing_path(i, j, next_camp):
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH - 1)
		next_camp = map_data[i + 1][random_j]
		
	current_camp.next_camps.append(next_camp)
	
	return next_camp.column
	
func _would_cross_existing_path(i: int, j: int, camp: Camp) -> bool:
	var left_neighbour: Camp
	var right_neighbour: Camp
	
	if j > 0:
		left_neighbour = map_data[i][j-1]
	if j < MAP_WIDTH - 1:
		right_neighbour = map_data[i][j + 1]
		
	if right_neighbour and camp.column > j:
		for next_camp: Camp in right_neighbour.next_camps:
			if next_camp.column < camp.column:
				return true
				
	if left_neighbour and camp.column < j:
		for next_camp: Camp in left_neighbour.next_camps:
			if next_camp.column > camp.column:
				return true
	
	return false

func _setup_random_camp_weights() -> void:
	random_camp_biome_weights[Camp.Biome.GRASS] = GRASS_ROOM_WEIGHT
	random_camp_biome_weights[Camp.Biome.DESERT] = GRASS_ROOM_WEIGHT + DESERT_ROOM_WEIGHT
	random_camp_biome_weights[Camp.Biome.ROCKY] = GRASS_ROOM_WEIGHT + DESERT_ROOM_WEIGHT + ROCKY_ROOM_WEIGHT
	
	random_camp_biome_total_weight = random_camp_biome_weights[Camp.Biome.ROCKY]

func _setup_camp_biomes() -> void:
	
	for camp: Camp in map_data[0]:
		if camp.next_camps.size() > 0:
			camp.biome = Camp.Biome.GRASS

	for current_floor in map_data:
		for camp: Camp in current_floor:
			for next_camp: Camp in camp.next_camps:
				if next_camp.biome == Camp.Biome.UNASSIGNED:
					_set_camp_randomly(next_camp)

func _set_camp_randomly(camp_to_set: Camp) -> void:
	var biome_candidate: Camp.Biome
	
	biome_candidate = _get_random_camp_biome_by_weight()
	
	camp_to_set.biome = biome_candidate
	
func _get_random_camp_biome_by_weight() -> Camp.Biome:
		var roll := randf_range(0.0, random_camp_biome_total_weight)
		
		for biome: Camp.Biome in random_camp_biome_weights:
			if random_camp_biome_weights[biome] > roll:
				return biome
		
		return Camp.Biome.GRASS
	
	
