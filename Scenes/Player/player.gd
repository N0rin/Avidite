extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -150.0
const JUMP_PEAK_FACTOR = 1

var air_time = 0
var peak_time = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta * get_gravity_factor(delta)

	if is_on_floor():
		air_time = 0
		peak_time = 0
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("GoLeft", "GoRight")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func get_gravity_factor(delta) -> float:
	var gravity_factor = 1
	
	if not is_on_floor():
		air_time += delta 
		if air_time > 0.15:
			if velocity.y < 0:
				peak_time += delta
			else:
				peak_time -= delta
		if peak_time > 0:
			gravity_factor = JUMP_PEAK_FACTOR
	
	return gravity_factor
