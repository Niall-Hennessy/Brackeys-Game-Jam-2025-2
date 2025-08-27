class_name Camp
extends Resource
#https://www.youtube.com/watch?v=7HYu7QXBuCY

enum Biome {UNASSIGNED, PLAINS, ARID, MOUNTAIN, RIVER, FOREST}

@export_group("Camp Properties")
@export var biome: Biome
@export var position: Vector2
@export var column: int
@export var row: int
@export var next_camps: Array[Camp]
@export var selected: bool = false

#func _to_string() -> String:
	#return "%s (%s)" % [column, Biome.keys()[biome][0]]
