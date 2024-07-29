extends Enemy
class_name Slime

@onready var flip = $Flip
@onready var animation = $Flip/Animation
@onready var ground_detector = $Flip/GroundDetector

func _ready():
	super()

func set_movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall():
		change_direction()
	
	if not ground_detector.has_overlapping_bodies():
		change_direction()

	velocity.x = move_toward(velocity.x, direction * move_speed, move_acceleration)

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

func activate():
	super()

func noise_received(position):
	scale *= 2
