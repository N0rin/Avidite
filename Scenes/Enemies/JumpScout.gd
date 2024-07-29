extends Scout
class_name JumpScout

@onready var wall_detector1 = $Flip/WallDetector1
@onready var wall_detector2 = $Flip/WallDetector2
@onready var wall_detector3 = $Flip/WallDetector3

func set_movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall() and flee_timer.time_left <= 0:
		change_direction()
	
	if not ground_detector.has_overlapping_bodies() and flee_timer.time_left <= 0:
		change_direction()
	
	if walking:
		velocity.x = move_toward(velocity.x, direction * move_speed, move_acceleration)
		
		var small_wall = wall_detector1.has_overlapping_bodies()
		var middle_wall = wall_detector2.has_overlapping_bodies()
		var high_wall = wall_detector3.has_overlapping_bodies()
		match([small_wall, middle_wall, high_wall]):
			[true, true, false] when is_on_floor():
				velocity.y = -jump_velocity
			[true, false, false] when is_on_floor():
				velocity.y = -jump_velocity * 0.8
	
func _on_turn_timer_timeout():
	super()

func _on_lookout_timer_timeout():
	walking = true

func _on_flee_timer_timeout():
	move_speed /= 2
	vision_cone.activate()


