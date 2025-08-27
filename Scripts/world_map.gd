class_name WorldMap
extends Node2D
#https://www.youtube.com/watch?v=7HYu7QXBuCY

const SCREEN_MOVE_SPEED := 30
const MAP_CAMP = preload("res://Scenes/map_camp.tscn")
const MAP_LINE = preload("res://Scenes/map_line.tscn")

@onready var map_generator: MapGenerator = $MapGenerator
@onready var lines: Node2D = %Lines
@onready var camps: Node2D = %Camps 
@onready var map_textures: Node2D = $MapTextures
@onready var camera_2d: Camera2D = $Camera2D

var map_data: Array[Array]
var camps_traversed: int
var last_camp: Camp
var camera_edge_y: int

func _ready() -> void:
	if not GameManager.map_data:
		generate_new_map()
		GameManager.map_data = map_data
		unlock_floor(0)
		print("Tgest")
	else:
		camps_traversed = 0
		map_data = GameManager.map_data
		create_map()

#func _on_new_map_button_pressed() -> void:
	#for child in camps.get_children():
		#child.free()
	#
	#for child in lines.get_children():
		#child.free()
	#
	#generate_new_map()
	#unlock_floor(0)

func _on_choose_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Camps/test_level.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		camera_2d.position.x -= SCREEN_MOVE_SPEED
	elif event.is_action_pressed("move_right"):
		camera_2d.position.x += SCREEN_MOVE_SPEED
	
	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0)

func generate_new_map() -> void:
	camps_traversed = 0
	map_data = map_generator.generate_map()
	create_map()
	
func create_map() -> void:
	for current_floor: Array in map_data:
		for camp: Camp in current_floor:
			if camp.next_camps.size() > 0:
				_spawn_camp(camp)
	
	var map_width_pixels := MapGenerator.X_Dist * (MapGenerator.MAP_HEIGHT - 1)
	map_textures.position.x = (get_viewport_rect().size.x - map_width_pixels) / 2
	map_textures.position.y = 0
	
func unlock_floor(which_floor: int = camps_traversed) -> void:
	for map_camp: MapCamp in camps.get_children():
		if map_camp.camp.column == which_floor:
			map_camp.available = true

func unlock_next_rooms() -> void:
	for map_camp: MapCamp in camps.get_children():
		if last_camp.next_camps.has(map_camp.camp):
			map_camp.available = true

func show_map() -> void:
	show()
	camera_2d.enabled = true

func hide_map() -> void:
	hide()
	camera_2d.enabled = false

func _spawn_camp(camp: Camp) -> void:
	var new_map_camp := MAP_CAMP.instantiate() as MapCamp
	camps.add_child(new_map_camp)
	new_map_camp.camp = camp
	new_map_camp.selected.connect(_on_map_camp_selected)
	_connect_lines(camp)
	
	if camp.selected and camp.column < camps_traversed:
		new_map_camp.show_selected()
		
func _connect_lines(camp: Camp) -> void:
	if camp.next_camps.is_empty():
		return
	
	for next: Camp in camp.next_camps:
		var new_map_line := MAP_LINE.instantiate() as Line2D
		new_map_line.add_point(camp.position)
		new_map_line.add_point(next.position)
		lines.add_child(new_map_line)
	
func _on_map_camp_selected(camp: Camp) -> void:
	for map_camp: MapCamp in camps.get_children():
		if map_camp.camp.column == camp.column:
			map_camp.available = false
			
	last_camp = camp
	camps_traversed += 1
