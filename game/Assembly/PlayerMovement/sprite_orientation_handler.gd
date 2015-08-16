
extends Sprite



func _ready():
	# Initialization here
	set_process_input(true)
	pass

func _input(event):
	if event.is_action("ui_left") && event.is_pressed():
		set_flip_h(true)
		pass
	elif event.is_action("ui_right") && event.is_pressed():
		set_flip_h(false)
		pass
	pass

