extends Enemy
class_name Igel

@export_group("Spawn")
@export var wall_climbing = false

@onready var flip = $Flip
@onready var animation = $Flip/Animation
@onready var ground_detector = $Flip/GroundDetector

func _ready():
	super()
	up_direction = Vector2(0,-1).rotated(rotation)

func set_movement(delta):
	velocity = velocity.rotated(-rotation)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall():
		change_direction()
	
	if not ground_detector.has_overlapping_bodies():
		change_direction()
	
	velocity.x = move_toward(velocity.x, direction * move_speed, move_acceleration)
	
	velocity = velocity.rotated(rotation)

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
