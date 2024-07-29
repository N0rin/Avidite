extends Node2D
class_name NoiseEvent

@onready var detection = $Area2D

var is_active = false
var size = 1
var SPEED = 4

func _process(delta):
	if scale.x > size:
		end()
	if is_active:
		set_scale(scale + (Vector2(SPEED, SPEED) * delta))

func play(value: float):
	show()
	size = value
	is_active = true
	detection.monitoring = true

func end():
	hide()
	is_active = false
	set_scale(Vector2(0.125,0.125))
	detection.monitoring = false


func _on_area_2d_body_entered(body):
	if body.has_method("noise_received") and body != get_parent():
		body.noise_received(global_position)
