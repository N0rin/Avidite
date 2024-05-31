extends Enemy
class_name Scout

@onready var flip = $Flip
@onready var animation = $Flip/Animation
@onready var ground_detector = $Flip/GroundDetector
@onready var vision_detector = $Flip/VisionDetector
@onready var vision_shape = $Flip/VisionShape
@onready var turn_timer = $TurnTimer
@onready var flee_timer = $FleeTimer
@onready var lookout_timer = $LookoutTimer

@export_group("Vision")
@export var target: Node
@export var distance = 80
@export var height = 24

var walking = true

func _ready():
	super()
	set_vision()

func set_movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall() and flee_timer.time_left <= 0:
		change_direction()
	
	if not ground_detector.has_overlapping_bodies() and flee_timer.time_left <= 0:
		change_direction()
	
	if walking:
		velocity.x = move_toward(velocity.x, direction * move_speed, move_acceleration)
	

func play_animation():
	animation.play("default")

func change_direction():
	if turn_timer.time_left > 0:
		return
	if lookout_timer.time_left > 0 and not ground_detector.has_overlapping_bodies():
		stop_walking()
		return
	
	toggle_direction()
	deactivate_vision()
	turn_timer.start()
	
func _on_turn_timer_timeout():
	activate_vision()
	lookout_timer.start()

func _on_vision_detector_body_entered(body):
	if body is Player and flee_timer.time_left <= 0:
		walking = true
		flee_timer.start()
		toggle_direction()
		deactivate_vision()
		move_speed *= 2

func _on_flee_timer_timeout():
	move_speed /= 2
	activate_vision()

func reset():
	super()
	
	if facing_right:
		direction = 1
		flip.scale.x = 1
	else:
		direction = -1
		flip.scale.x = -1

func set_vision():
	var vectors : PackedVector2Array
	vectors.append(Vector2(0,0))
	vectors.append(Vector2(distance,0))
	vectors.append(Vector2(distance,-height))
	vectors.append(Vector2(0,-7))
	vision_shape.polygon = vectors
	$Flip/VisionDetector/CollisionShape2D.polygon = vectors

func deactivate_vision():
	vision_detector.set_deferred("monitoring",false)
	vision_shape.hide()

func activate_vision():
	vision_detector.set_deferred("monitoring",true)
	vision_shape.show()

func toggle_direction():
	direction *= -1
	flip.scale.x *= -1

func _on_lookout_timer_timeout():
	walking = true

func stop_walking():
	walking = false
	velocity.x = 0

func activate():
	super()
