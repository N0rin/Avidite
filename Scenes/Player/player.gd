extends CharacterBody2D
class_name Player

signal hit

@export_group("Spawn")
@onready var spawn_position: Vector2 = position
@export_group("Walk")
@export var move_speed = 100.0
@export var move_acceleration = 10
@export var move_deceleration = 10
@export_group("Jump")
@export var jump_duration = 0.5
@export var jump_height = 18.75
@export_subgroup("Tweaks")
@export var jump_peak_portion = 0.25
@export var jump_peak_factor = 0.5
@export var modular_jump_factor = 4.0
@export_subgroup("Wall Jump")
@export_range(0, 180, 0.1, "radians_as_degrees") var wall_jump_angle = PI / 8
@export var wall_jump_strength = 1.0
@export_subgroup("Assists")
@export var jump_buffer = 0.1
@export var wall_jump_buffer = 0.1
@export var koyote_time = 0.1
@export var max_fall_velocity_factor = 4.0
@export_group("Air Movement")
@export var wall_glide_factor = 0.3

var jump_input = 0
var fall_of_time = 0
var wall_timer = 0
var jump_timer = 0
var ignore = false
@onready var jump_velocity = 4 * (jump_height / jump_duration)
@onready var gravity = 2 * (jump_velocity / jump_duration)

@onready var animation = $Animation

func _physics_process(delta):

	var debug_velocity = velocity
	
	if not is_on_floor():
		velocity.y += gravity * delta * get_gravity_factor(delta)
		fall_of_time += delta
		jump_timer += delta

	if is_on_floor():
		fall_of_time = 0
		jump_timer = 0
	
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
			jump_direction = jump_direction.rotated(-wall_jump_angle)
		if get_wall_normal().x > 0:
			jump_direction = jump_direction.rotated(wall_jump_angle)
		velocity = jump_direction * jump_velocity * wall_jump_strength
		jump_input = 0
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("GoLeft", "GoRight")
	if direction:
		velocity.x = move_toward(velocity.x, direction * move_speed, move_acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, move_deceleration)
	
	if velocity.y > jump_velocity * max_fall_velocity_factor:
		velocity.y = jump_velocity * max_fall_velocity_factor
	
	if is_on_wall():
		if Input.is_action_pressed("Grab") and not Input.is_action_just_pressed("Jump"):
			velocity.y = 0
		if velocity.y > jump_velocity * wall_glide_factor:
			velocity.y = jump_velocity * wall_glide_factor
	play_character_animation()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is Slime:
			emit_signal("hit")
	
	move_and_slide()

func play_character_animation():
	if velocity.x < 0:
		animation.flip_h = true
	elif velocity.x > 0:
		animation.flip_h = false
	
	if is_on_floor():
		if velocity.x == 0:
			animation.play("standing")
		else:
			animation.play("walk")
	elif is_on_wall():
		animation.play("on_wall")
	elif abs(velocity.y) <= jump_velocity * jump_peak_portion:
		animation.play("gliding")
	elif velocity.y < 0:
		animation.play("jump")
	elif velocity.y >= 0:
		animation.play("fall")

func get_gravity_factor(delta) -> float:
	var gravity_factor = 1
	
	if velocity.y < -10 and not Input.is_action_pressed("Jump"):
		gravity_factor = modular_jump_factor
	
	if abs(velocity.y) < jump_velocity * jump_peak_portion:
		gravity_factor = jump_peak_factor

	return gravity_factor

func reset():
	velocity = Vector2.ZERO
