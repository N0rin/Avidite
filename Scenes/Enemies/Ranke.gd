extends Enemy
class_name Ranke

@onready var animation_player = $Flip/AnimationPlayer

func play_animation():
	animation_player.play("idle")
