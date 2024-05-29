extends Enemy
class_name Slime

@onready var flip = $Flip
@onready var animation = $Flip/Animation
@onready var ground_detector = $Flip/GroundDetector

func _ready():
	spawn_position = position
	reset()
	change_direction()

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall():
		change_direction()
	
	if not ground_detector.has_overlapping_bodies():
		change_direction()

	velocity.x = move_toward(velocity.x, direction * move_speed, move_acceleration)
	
	play_animation()
	move_and_slide()

func play_animation():
	animation.play("default")

func change_direction():
	direction *= -1
	flip.scale.x *= -1

func reset():
	super()
	
	if facing_right:
		direction = 1
		flip.scale.x = 1
	else:
		direction = -1
		flip.scale.x = -1
