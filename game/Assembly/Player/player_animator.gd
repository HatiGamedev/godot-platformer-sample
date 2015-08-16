
extends AnimationPlayer

var player = preload("../PlayerMovement/player_movement.gd")

func _ready():
	pass




func _on_Player_enter_state( StateName ):
	if StateName == player.PlayerState.Attack:
		self.play("attack")
		pass
	pass # replace with function body
