extends Enemy
class_name Shootplant

@onready var projectile_scene = preload("res://spit.tscn")

func noise_received(position):
	var direction = position - global_position
	shoot(direction)

func shoot(direction: Vector2):
	if $SpitTimer.get_time_left() > 0:
		return
	
	var angle = direction.angle()
	if angle < 7*PI/8 and angle > PI/8:
		return
	
	
	if direction.x < 0:
		$Flip.scale.x = 1
	else:
		$Flip.scale.x = -1
	
	for value in range(1,4):
		var projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)
		projectile.position = $ShootStart.global_position
		projectile.velocity = direction + Vector2(0,(value-2) * 5)
	
	$Flip/Head.play("spit")
	$SpitTimer.start()

func _on_head_animation_finished():
	$Flip/Head.play("default")
