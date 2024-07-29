extends Node2D
class_name VisionCone

signal detected(object : Object)

@export_flags_2d_physics var collision_mask = 1
var deactivated = false
var detection_time = 0.1
var detection_counter = 0
var detection_list : Array

func _ready():
	for child in get_children():
		if child is RayCast2D:
			child.collision_mask = collision_mask

func _process(delta):
	if deactivated:
		return
	
	var detected : Array
	var vision_shape : PackedVector2Array = []
	vision_shape.append(Vector2.ZERO)
	
	for child in get_children():
		if child is RayCast2D:
			if child.is_colliding():
				var vector = (child.get_collision_point() - global_position)
				if global_rotation != rotation:
					vector.x *= -1
				vision_shape.append(vector)
				var test = global_rotation
				if child.get_collider().is_in_group("Creature"):
					if detected.find(child.get_collider()) == -1:
						detected.append(child.get_collider())
			else:
				vision_shape.append(child.position + child.target_position.rotated(child.rotation))
	
	if detected.is_empty():
		detection_counter = 0
	else:
		detection_counter += delta
	if detection_counter >= detection_time:
		for creature in detected:
			emit_signal("detected", creature)
	
	$VisionShape.polygon = vision_shape

func activate():
	deactivated = false
	$VisionShape.show()
	
func deactivate():
	deactivated = true
	$VisionShape.hide()
