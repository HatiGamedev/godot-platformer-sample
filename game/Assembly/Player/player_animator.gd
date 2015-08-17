
extends AnimationPlayer

var player = preload("../PlayerMovement/player_movement.gd")

var playerInst

func _ready():
	playerInst = get_node("../")
	pass
	

var prevJump = ""


func _on_Player_enter_state( StateName ):
	if StateName == player.PlayerState.Attack:
		var cur = get_current_animation() # Get the current animation
		self.play("attack") # Play attack
		clear_queue() # attack defaults to idle
		queue(cur) # play the last one instead
		pass
	elif StateName == player.PlayerState.Walk:
		self.play("walk")
		if prevJump == "idle":
			prevJump = "walk"
		pass
	elif StateName == player.PlayerState.Idle:
		self.play("idle")
		if prevJump != "":
			prevJump = ""
		pass
	elif StateName == player.PlayerState.JumpStart:
		prevJump = get_current_animation()
		self.play("jump_start")
		pass
	elif StateName == player.PlayerState.Falling:
		if prevJump == "":
			prevJump = get_current_animation()
		self.play("jump_end")
		pass
	elif StateName == player.PlayerState.Landing:
		if prevJump != "":
			clear_queue()
			queue(prevJump)
			prevJump = ""
			pass
		pass
	pass # replace with function body



func _on_AnimationPlayer_finished():
	pass # replace with function body
