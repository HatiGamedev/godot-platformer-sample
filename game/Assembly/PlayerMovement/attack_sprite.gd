	
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var Damage = 1

func _ready():
	# Initialization here
	pass

func _on_Attack_body_enter( body ):
	if(body.has_method("hit")):
		body.hit(Damage)
	pass # replace with function body

func _on_AnimationPlayer_finished():
	queue_free()
	pass # replace with function body