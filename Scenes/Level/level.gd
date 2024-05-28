extends Node2D


func _process(delta):
	if Input.is_action_pressed("Reset"):
		reset()

func reset():
	for object in $TileMap.get_children():
		if object is CharacterBody2D:
			object.velocity = Vector2.ZERO
			object.position = object.spawn_position
			object.reset()

func _on_player_hit():
	reset()
