extends CharacterBody2D

@export_range(0, 300, 1) var speed: float = 100 
var facing_direction = "down"

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var anim = "down"
	
	if direction.x > 0:
		facing_direction = "right"
		anim = "walk_right"
	elif direction.x < 0:
		facing_direction = "left"
		anim = "walk_left"
	elif direction.y > 0:
		facing_direction = "down"
		anim = "walk_down"
	elif direction.y < 0:
		facing_direction = "up"
		anim = "walk_up"
	else:
		anim = "idle_" + facing_direction
		
	$AnimatedSprite2D.play(anim)
	velocity = direction * speed
	move_and_slide()
