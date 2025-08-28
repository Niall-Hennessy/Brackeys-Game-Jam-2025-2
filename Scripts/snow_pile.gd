extends Node2D

func _process(delta: float) -> void:
	self.set_visible(GameManager.winter_intensity > 1)
