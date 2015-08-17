
extends SamplePlayer2D

var Player = preload("../PlayerMovement/player_movement.gd")

func _ready():
	pass




func _on_Player_enter_state( StateName ):
	prints("audio",StateName)
	if StateName == Player.PlayerState.Landing:
		self.play("landing-00")
	elif StateName == Player.PlayerState.Attack:
		self.play("attack-00")
	pass # replace with function body
