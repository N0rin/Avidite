extends CharacterBody2D

@export_category("Walk")
@export var move_speed = 100.0
@export var move_acceleration = 10
@export var move_deceleration = 10
@export_category("Jump")
@export var jump_duration = 0.5
@export var jump_height = 18.75
@export var jump_peak_portion = 0.25
@export var jump_peak_factor = 0.5
@export_category("Wall Jump")
@export_range(0, 180, 0.1, "radians_as_degrees") var wall_jump_angle = PI / 8
@export var wall_jump_strength = 1
@export_category("Assists")
@export var jump_buffer = 0.1
@export var wall_jump_buffer = 0.1
@export var koyote_time = 0.1

var jump_input = 0
var fall_of_time = 0
var wall_timer = 0
@onready var jump_velocity = 4 * (jump_height / jump_duration)
@onready var gravity = 2 * (jump_velocity / jump_duration)


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta * get_gravity_factor(delta)
		fall_of_time += delta

	if is_on_floor():
		fall_of_time = 0
	
	wall_timer += delta
	jump_input -= delta
	
	if Input.is_action_just_pressed("Jump"):
		jump_input = jump_buffer
	
	if jump_input > 0 and (is_on_floor() or fall_of_time < koyote_time):
		velocity.y = -jump_velocity
		jump_input = 0
		fall_of_time = koyote_time
	
	if is_on_wall():
		wall_timer = 0
	
	if jump_input > 0 and wall_timer < wall_jump_buffer:
		var jump_direction = Vector2(0, -1)
		if get_wall_normal().x < 0:
			jump_direction = jump_direction.from_angle(-PI/2 - wall_jump_angle)
		if get_wall_normal().x > 0:
			jump_direction = jump_direction.from_angle(-PI/2 + wall_jump_angle)
		velocity = jump_direction * jump_velocity * wall_jump_strength
		jump_input = 0
	
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
	
	if abs(velocity.y) < jump_velocity * jump_peak_portion:
		gravity_factor = jump_peak_factor

	return gravity_factor
