extends CharacterBody2D
class_name Spit

var SPEED = 100

func _ready():
	$Scale/Animation.play("default")

func _process(delta):
	if move_and_collide(velocity.normalized() * delta * SPEED):
		velocity = Vector2.ZERO
		$AnimationPlayer.play("explosion")
		$Scale/Animation.play("boom")
		$noise_event.play(1)

func reset():
	queue_free()


func _on_animation_player_animation_finished(anim_name):
	queue_free()
