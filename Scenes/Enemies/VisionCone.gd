extends Node2D
class_name VisionCone

signal detected(object : Object)

@export_flags_2d_physics var collision_mask = 1
var deactivated = false
var detection_time = 0.3
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
	for detection in detection_list:
		if detected.find(detection[0]) == -1:
			detection_list.erase(detection)
	for detection in detection_list:
		for creature in detected:
			if detection[0] == creature:
				detection[1] += delta
				detected.erase(creature)
	for creature in detected:
		detection_list.append([creature, 0])
				
		for detection in detection_list:
			if detection[1] >= detection_time:
				emit_signal("detected", detection[0])
	
	$VisionShape.polygon = vision_shape

func activate():
	deactivated = false
	$VisionShape.show()
	
func deactivate():
	deactivated = true
	$VisionShape.hide()
