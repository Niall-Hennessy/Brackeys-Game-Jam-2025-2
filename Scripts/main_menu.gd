extends Node2D


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/WorldMap/world_map.tscn")
	GameManager.initialise_vars()



func _on_quit_button_pressed() -> void:
	get_tree().quit()

# add either a settings menu or mute SFX + mute music buttons?
