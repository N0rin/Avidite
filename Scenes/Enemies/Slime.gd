extends CharacterBody2D
class_name Slime

@export_group("Spawn")
@export var spawn_position: Vector2
@export_group("Walk")
@export var move_speed = 30.0
@export var move_acceleration = 10
@export var move_deceleration = 10
@export_group("Jump")
@export var jump_duration = 0.5
@export var jump_height = 18.75

@onready var jump_velocity = 4 * (jump_height / jump_duration)
@onready var gravity = 2 * (jump_velocity / jump_duration)

@onready var flip = $Flip
@onready var animation = $Flip/Animation
@onready var ground_detector = $Flip/GroundDetector
var direction = 1

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall():
		change_direction()
	
	if not ground_detector.has_overlapping_bodies():
		change_direction()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * move_speed, move_acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, move_deceleration)
	
	play_animation()
	move_and_slide()

func play_animation():
	animation.play("default")

func change_direction():
	direction *= -1
	flip.scale.x *= -1

func reset():
	direction = 1
	flip.scale.x = 1
