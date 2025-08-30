class_name MapGenerator
extends Node
#https://www.youtube.com/watch?v=7HYu7QXBuCY

@export var plains_camp_weight = 11
@export var arid_camp_weight = 3
@export var mountain_camp_weight = 2
@export var river_camp_weight = 5
@export var forest_camp_weight = 8

const X_Dist := 30
const Y_Dist := 25
const PLACEMENT_RANDOMNESS := 5
const FLOORS := 10
const MAP_HEIGHT := 10
const PATHS := 8

var map_data: Array[Array]

var rng = RandomNumberGenerator.new()
var camp_biomes_array = [Camp.Biome.PLAINS, Camp.Biome.ARID, Camp.Biome.MOUNTAIN, Camp.Biome.RIVER, Camp.Biome.FOREST]
var early_weights = PackedFloat32Array([plains_camp_weight, arid_camp_weight, mountain_camp_weight, river_camp_weight, forest_camp_weight])
var early_mid_weights = PackedFloat32Array([plains_camp_weight * 0.6, arid_camp_weight * 0, mountain_camp_weight, river_camp_weight * 0.6, forest_camp_weight * 2.5])
var mid_weights = PackedFloat32Array([plains_camp_weight * 0.3, arid_camp_weight * 0, mountain_camp_weight * 2, river_camp_weight * 2.5, forest_camp_weight * 0.3])
var late_mid_weights = PackedFloat32Array([plains_camp_weight * 0, arid_camp_weight, mountain_camp_weight * 4, river_camp_weight * 0.5, forest_camp_weight * 0.3])
var late_weights = PackedFloat32Array([plains_camp_weight * 0, arid_camp_weight * 3, mountain_camp_weight, river_camp_weight * 0.1, forest_camp_weight * 0])

func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points: Array[int]= [2,2,2,2,2,2]
	
	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = _setup_connection(i, current_j)
			
	_setup_final_camp()
	_setup_camp_biomes()
	
	return map_data

func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for i in FLOORS:
		var adjacent_camps: Array[Camp] = []
	
		for j in MAP_HEIGHT:
			var current_camp := Camp.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_camp.position = Vector2(i * i/8 * X_Dist + 50 * i, j * -Y_Dist) + offset
			current_camp.column = i
			current_camp.row = j
			current_camp.next_camps = []
			
			if i == FLOORS - 1:
				current_camp.position.x = (i + 1) * i/8 * X_Dist + 50 * i
				current_camp.position.y = MAP_HEIGHT/2
			
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

func _setup_final_camp() -> void:
	var middle := floori(MAP_HEIGHT * 0.5)
	var final_camp := map_data[FLOORS - 1][middle] as Camp
	
	for j in MAP_HEIGHT:
		var current_camp = map_data[FLOORS - 2][j] as Camp
		if  current_camp.next_camps:
			current_camp.next_camps = [] as Array[Camp]
			current_camp.next_camps.append(final_camp)
			
	final_camp.biome = Camp.Biome.TOWN

func _setup_camp_biomes() -> void:
	for camp: Camp in map_data[0]:
		if camp.next_camps.size() > 0:
			camp.biome = Camp.Biome.PLAINS

	for i in range(FLOORS):
		for camp: Camp in map_data[i]:
			for next_camp: Camp in camp.next_camps:
				if next_camp.biome == Camp.Biome.UNASSIGNED:
					if i < 2:
						next_camp.biome = camp_biomes_array[rng.rand_weighted(early_weights)]
					elif  i >= 2 and i <=3:
						next_camp.biome = camp_biomes_array[rng.rand_weighted(early_mid_weights)]
					elif  i >= 4 and i <=6:
						next_camp.biome = camp_biomes_array[rng.rand_weighted(mid_weights)]
					elif  i >= 7 and i <=10:
						next_camp.biome = camp_biomes_array[rng.rand_weighted(late_mid_weights)]
					elif  i >= 11 and i <=15:
						next_camp.biome = camp_biomes_array[rng.rand_weighted(late_weights)]
					else:
						next_camp.biome = camp_biomes_array[rng.rand_weighted(early_weights)]
						
	#for current_floor in map_data:
		#for camp: Camp in current_floor:
			#for next_camp: Camp in camp.next_camps:
				#if next_camp.biome == Camp.Biome.UNASSIGNED:
					#next_camp.biome = camp_biomes_array[rng.rand_weighted(weights)]
