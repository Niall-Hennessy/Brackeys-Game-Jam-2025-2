class_name MapCamp
extends Area2D

signal selected(camp: Camp)

#Consider removing the Vector2.ONE part below
const ICONS := {
	Camp.Biome.UNASSIGNED: [null, Vector2.ONE],
	Camp.Biome.GRASS: [preload("res://Assets/grass_camp_temp.png"), Vector2.ONE],
	Camp.Biome.DESERT: [preload("res://Assets/desert_camp_temp.png"), Vector2.ONE],
	Camp.Biome.ROCKY: [preload("res://Assets/rocky_camp_temp.png"), Vector2.ONE]
}

@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var available := false : set = set_available
var camp: Camp : set = set_camp

func set_available(new_value: bool) -> void:
	available = new_value

	if available:
		animation_player.play("Selected")
	elif not camp.selected:
		animation_player.play("RESET")

func set_camp(new_data: Camp) -> void:
	camp = new_data
	position = camp.position
	sprite_2d.texture = ICONS[camp.biome][0]
	sprite_2d.scale = ICONS[camp.biome][1]

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return

	camp.selected = true
	animation_player.play("Selected")
	
func _on_map_camp_selected() -> void:
	selected.emit(camp)
