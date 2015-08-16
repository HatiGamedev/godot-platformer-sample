
extends AnimationPlayer

var player = preload("../PlayerMovement/player_movement.gd")

func _ready():
	pass




func _on_Player_enter_state( StateName ):
	if StateName == player.PlayerStates.ATTACK_STATE:
		print("test successful")
		pass
	pass # replace with function body
