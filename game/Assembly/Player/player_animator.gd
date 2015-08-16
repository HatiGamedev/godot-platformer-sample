
extends AnimationPlayer

var player = preload("../PlayerMovement/player_movement.gd")

func _ready():
	pass
	
var prevAnimation = ""

func _on_Player_enter_state( StateName ):
	if StateName == player.PlayerState.Attack:
		var cur = get_current_animation() # Get the current animation
		self.play("attack") # Play attack
		clear_queue() # attack defaults to idle
		queue(cur) # play the last one instead
		pass
	elif StateName == player.PlayerState.Walk:
		self.play("walk")
		pass
	elif StateName == player.PlayerState.Idle:
		self.play("idle")
		pass
	pass # replace with function body



func _on_AnimationPlayer_finished():
	pass # replace with function body
