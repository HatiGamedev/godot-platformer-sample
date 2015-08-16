
extends Navigation2D

# member variables here, example:
# var a=2
# var b="textvar"


func _ready():
	# Initialization here
	set_fixed_process(true)
	pass


func _fixed_process(delta):
	var player = get_node("../../Player")

	var l = get_simple_path(self.get_global_pos(), player.get_global_pos())
	
	var parent = get_node("../")
	print(l.size())
	"""
	parent.set_pos(parent.get_pos() + l.get(0)*delta)
	"""
	pass

