extends CharacterBody2D

@export_category("Walk")
@export var move_speed = 100.0
@export var move_acceleration = 100
@export var move_deceleration = 100
@export_category("Jump")
@export var jump_duration = 0.5
@export var jump_height = 18.75
@export var jump_peak_portion = 0.2
@export var jump_peak_factor = 0.5
@export_category("Assists")
@export var jump_buffer = 0.2
@export var koyote_time = 0.2

var air_time = 0
var peak_time = 0
var jump_input = 0
var fall_of_time = 0
@onready var jump_velocity = 4 * (jump_height / jump_duration)
@onready var gravity = 2 * (jump_velocity / jump_duration)


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta * get_gravity_factor(delta)
		air_time += delta 
		fall_of_time += delta

	if is_on_floor():
		air_time = 0
		peak_time = 0
		fall_of_time = 0
	
	# Handle jump.
	jump_input -= delta
	
	if Input.is_action_just_pressed("Jump"):
		jump_input = jump_buffer
	
	if jump_input > 0 and (is_on_floor() or fall_of_time < koyote_time):
		velocity.y = -jump_velocity
		jump_input = 0
		fall_of_time = koyote_time

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("GoLeft", "GoRight")
	if direction:
		velocity.x = move_toward(velocity.x, direction * move_speed, move_acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, move_deceleration)

	move_and_slide()

func get_gravity_factor(delta) -> float:
	var gravity_factor = 1
	
	if air_time > 0.5 * jump_duration * (1-jump_peak_portion):
		if velocity.y < 0:
			peak_time += delta
		else:
			peak_time -= delta
	if peak_time > 0:
			gravity_factor = jump_peak_factor
	
	return gravity_factor
