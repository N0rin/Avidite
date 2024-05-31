extends CharacterBody2D
class_name Enemy

@export_group("Spawn")
var spawn_position: Vector2
@export var facing_right = true
@export_group("Walk")
@export var move_speed = 30.0
@export var move_acceleration = 10
@export var move_deceleration = 10
@export_group("Jump")
@export var jump_duration = 0.5
@export var jump_height = 18.75

@onready var jump_velocity = 4 * (jump_height / jump_duration)
@onready var gravity = 2 * (jump_velocity / jump_duration)

var deactivated = true
var direction = 1

func _physics_process(delta):
	if not deactivated:
		set_movement(delta)
	
	play_animation()
	move_and_slide()

func _ready():
	set_spawn()

func reset():
	velocity = Vector2.ZERO
	position = spawn_position

func set_spawn():
	spawn_position = position

func activate():
	deactivated = false

func set_movement(_delta):
	pass

func play_animation():
	pass
