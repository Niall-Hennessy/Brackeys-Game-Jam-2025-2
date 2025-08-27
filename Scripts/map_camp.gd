class_name MapCamp
extends Area2D
#https://www.youtube.com/watch?v=7HYu7QXBuCY

signal selected(camp: Camp)

const ICONS := {
	Camp.Biome.UNASSIGNED: [null],
	Camp.Biome.PLAINS: [preload("res://Assets/MapCamps/plains_camp_temp.png")],
	Camp.Biome.ARID: [preload("res://Assets/MapCamps/arid_camp_temp.png")],
	Camp.Biome.MOUNTAIN: [preload("res://Assets/MapCamps/mountain_camp_temp.png")],
	Camp.Biome.RIVER: [preload("res://Assets/MapCamps/river_camp_temp.png")],
	Camp.Biome.FOREST: [preload("res://Assets/MapCamps/forest_camp_temp.png")]
}

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var available := false : set = set_available
var camp: Camp : set = set_camp

func set_available(new_value: bool) -> void:
	available = new_value

	if available:
		animation_player.play("Pulsate")
	if not camp.selected:
		animation_player.play("RESET")

func set_camp(new_data: Camp) -> void:
	camp = new_data
	position = camp.position
	sprite_2d.texture = ICONS[camp.biome][0]

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_click"):
		return

	camp.selected = true
	animation_player.play("Pulsate")
	
func _on_map_camp_selected() -> void:
	selected.emit(camp)
