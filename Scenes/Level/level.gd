extends Node2D


func _process(_delta):
	if Input.is_action_pressed("Reset"):
		reset()

func reset():
	for object in $TileMap.get_children():
		if object is CharacterBody2D:
			object.reset()

func _on_player_hit():
	reset()


func _on_start_delay_timeout():
	for object in $TileMap.get_children():
		if object.has_method("activate"):
			object.activate()
