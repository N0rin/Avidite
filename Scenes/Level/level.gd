extends Node2D


func _process(delta):
	if Input.is_action_pressed("Reset"):
		reset()

func reset():
	for object in $TileMap.get_children():
		if object is CharacterBody2D:
			object.velocity = Vector2.ZERO
			object.position = object.spawn_position
			if object is Player:
				object.reset()
			if object is Slime:
				object.direction = 1



func _on_player_hit():
	reset()
