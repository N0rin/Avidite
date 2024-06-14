extends Enemy
class_name Scout

@onready var flip = $Flip
@onready var animation = $Flip/Animation
@onready var ground_detector = $Flip/GroundDetector
@onready var vision_cone = $Flip/VisionCone
@onready var turn_timer = $TurnTimer
@onready var flee_timer = $FleeTimer
@onready var lookout_timer = $LookoutTimer

@export_group("Vision")
@export var target: Node
@export var distance = 80
@export var height = 24
@export var detection_time = 0.3

var walking = true

func _ready():
	super()

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
	vision_cone.deactivate()
	turn_timer.start()
	
func _on_turn_timer_timeout():
	vision_cone.activate()
	lookout_timer.start()

func _on_flee_timer_timeout():
	move_speed /= 2
	vision_cone.activate()

func reset():
	super()
	
	if facing_right:
		direction = 1
		flip.scale.x = 1
	else:
		direction = -1
		flip.scale.x = -1

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


func _on_vision_cone_detected(object):
	if object is Player and flee_timer.time_left <= 0:
		walking = true
		flee_timer.start()
		toggle_direction()
		vision_cone.deactivate()
		move_speed *= 2
