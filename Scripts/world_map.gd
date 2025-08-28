class_name WorldMap
extends Node2D
#https://www.youtube.com/watch?v=7HYu7QXBuCY

const SCREEN_MOVE_SPEED := 30
const MAP_CAMP = preload("res://Scenes/map_camp.tscn")
const MAP_LINE = preload("res://Scenes/map_line.tscn")

const MAPS := {
	Camp.Biome.UNASSIGNED: null,
	Camp.Biome.PLAINS: "res://Scenes/Camps/template_plains_camp.tscn",
	Camp.Biome.ARID: "res://Scenes/Camps/template_arid_camp.tscn",
	Camp.Biome.MOUNTAIN: "res://Scenes/Camps/template_mountain_camp.tscn",
	Camp.Biome.RIVER: "res://Scenes/Camps/template_river_camp.tscn",
	Camp.Biome.FOREST: "res://Scenes/Camps/template_forest_camp.tscn"
}

var tween: Tween

@onready var map_generator: MapGenerator = $MapGenerator
@onready var lines: Node2D = %Lines
@onready var camps: Node2D = %Camps 
@onready var map_textures: Node2D = $MapTextures
@onready var camera_2d: Camera2D = $Camera2D
@onready var player_sprite: Sprite2D = $MapTextures/PlayerSprite
@onready var biscuit_slider: HSlider = $CanvasLayer/NumberOfBiscuitsSlider

var camera_edge_y: int

var map_data: Array[Array]
var camps_traversed: int

var current_camp: Camp
var selected_camp: Camp
var first_camp: Camp

var player_position: Vector2

var travel_progress: int
var biscuits_per_travel: int
var between_camps: bool = false

func _ready() -> void:
	if not GameManager.map_data:
		travel_progress = 0
		generate_new_map()
		GameManager.map_data = map_data
		player_position = first_camp.position
		current_camp = first_camp
		biscuits_per_travel = 3
		unlock_next_rooms()
	else:
		camps_traversed = GameManager.camps_traversed
		map_data = GameManager.map_data
		create_map()
		player_position = GameManager.player_world_map_position
		current_camp = GameManager.world_map_current_camp
		travel_progress = GameManager.travel_progress
		biscuits_per_travel = GameManager.biscuits_per_travel
		if GameManager.world_map_selected_camp:
			selected_camp = GameManager.world_map_selected_camp
		unlock_next_rooms()
		
	player_sprite.position = player_position
	update_biscuit_slider()
	update_button_text()

func _on_choose_button_pressed() -> void:
	var current_biscuits = biscuit_slider.get_value()
	if not selected_camp or current_biscuits <= 0:
		return
	
	for map_camp: MapCamp in camps.get_children():
			if map_camp.camp.column == selected_camp.column:
				map_camp.available = false
				map_camp.end_animation()
	
	GameManager.world_map_selected_camp = selected_camp
		
	if current_biscuits < biscuits_per_travel - travel_progress:
		travel_progress += current_biscuits
		GameManager.biscuits -= current_biscuits
	else:
		GameManager.biscuits -= biscuits_per_travel - travel_progress
		travel_progress += biscuits_per_travel - travel_progress
	
	#create a travel progress variable that holds how far along the path the player is and perform all calculations based off of that
	
	var vec2 = selected_camp.position - player_sprite.position
	vec2 = vec2/biscuits_per_travel
	
	tween = create_tween()
	tween.tween_property(player_sprite, "position", player_sprite.position + vec2 * travel_progress, 1)
	
	await tween.finished
	
	between_camps = true
	if travel_progress == biscuits_per_travel:
		
		between_camps = false
		current_camp = selected_camp
		GameManager.world_map_selected_camp = null
		
		camps_traversed += 1
		if camps_traversed == map_generator.FLOORS:
			get_tree().change_scene_to_file("res://Scenes/Screens/victory_screen.tscn")			
		
		travel_progress = 0
		biscuits_per_travel += 1
		GameManager.biscuits_per_travel = biscuits_per_travel
		print(biscuits_per_travel)
		GameManager.travel_progress = 0
		unlock_next_rooms()
		update_biscuit_slider()
		update_button_text()

func _on_setup_camp_button_pressed() -> void:
	GameManager.camps_traversed = camps_traversed
	GameManager.player_world_map_position = player_sprite.position
	GameManager.world_map_current_camp = current_camp
	GameManager.travel_progress = travel_progress
	get_tree().change_scene_to_file(MAPS[current_camp.biome])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		camera_2d.position.x -= SCREEN_MOVE_SPEED
	elif event.is_action_pressed("move_right"):
		camera_2d.position.x += SCREEN_MOVE_SPEED
	
	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0)

func generate_new_map() -> void:
	camps_traversed = 1
	map_data = map_generator.generate_map()
	create_map()
	
func create_map() -> void:
	var has_found_first = false
	
	for current_floor: Array in map_data:
		for camp: Camp in current_floor:
			if camp.next_camps.size() > 0:
				if not has_found_first:
					first_camp = camp
					has_found_first = true
				_spawn_camp(camp)
	
	var middle := floori(MapGenerator.MAP_HEIGHT * 0.5)
	_spawn_camp(map_data[MapGenerator.FLOORS - 1][middle])
	
	var map_width_pixels := MapGenerator.X_Dist * (MapGenerator.MAP_HEIGHT - 1)
	map_textures.position.x = (get_viewport_rect().size.x - map_width_pixels) / 2
	map_textures.position.y = 0
	
func unlock_floor(which_floor: int = camps_traversed) -> void:
	for map_camp: MapCamp in camps.get_children():
		if map_camp.camp.column == which_floor:
			map_camp.available = true

func unlock_next_rooms() -> void:
	for map_camp: MapCamp in camps.get_children():
		if current_camp.next_camps.has(map_camp.camp):
			map_camp.available = true

func _spawn_camp(camp: Camp) -> void:
	var new_map_camp := MAP_CAMP.instantiate() as MapCamp
	camps.add_child(new_map_camp)
	new_map_camp.camp = camp
	new_map_camp.selected.connect(_on_map_camp_selected)
	_connect_lines(camp)
		
func _connect_lines(camp: Camp) -> void:
	if camp.next_camps.is_empty():
		return
	
	for next: Camp in camp.next_camps:
		
		var new_map_line := MAP_LINE.instantiate() as Line2D
		
		match camp.biome:
			Camp.Biome.PLAINS:
				new_map_line.texture = load("res://Assets/MapLines/lime_line.png")
			Camp.Biome.ARID:
				new_map_line.texture = load("res://Assets/MapLines/yellow_line.png")
			Camp.Biome.MOUNTAIN:
				new_map_line.texture = load("res://Assets/MapLines/grey_line.png")
			Camp.Biome.FOREST:
				new_map_line.texture = load("res://Assets/MapLines/green_line.png")
			Camp.Biome.RIVER:
				new_map_line.texture = load("res://Assets/MapLines/red_line.png")
		
		
		new_map_line.add_point(camp.position)
		new_map_line.add_point(next.position)
		lines.add_child(new_map_line)
	
func _on_map_camp_selected(map_camp_sent: MapCamp) -> void:
	for map_camp: MapCamp in camps.get_children():
		if map_camp != map_camp_sent:
			map_camp.set_is_selected(false)
	
	selected_camp = map_camp_sent.camp

func update_biscuit_slider() -> void:
	# set the slider's max value to the number of biscuits you have
	biscuit_slider.max_value = GameManager.biscuits
	biscuit_slider.tick_count = GameManager.biscuits
	
func update_button_text() -> void:
	# change the button text to reflect whether a destination has been chosen or not
	if between_camps:
		$CanvasLayer/ChooseButton.text = "Choose Destination and Travel"
	else:
		$CanvasLayer/ChooseButton.text = "Travel Towards Destination"

func _on_number_of_biscuits_slider_value_changed(value: float) -> void:
	update_biscuit_slider()
	$CanvasLayer/NumberOfBiscuitsLabel.text = str(int(biscuit_slider.get_value()))
	
