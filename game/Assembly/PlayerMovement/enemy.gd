
extends RigidBody2D

export var Hitpoints=1
export var DamageImmuneTimeMS=1.0

export(int) var Armor =1


signal was_hit
var ImmunityTimer
var DamageImmuneTimer = Timer.new()

var Nav
var current_path
var hasPath=false

func _draw():
	if !hasPath:
		return
	if current_path.size() > 0:
		for i in range(1):
			draw_circle(current_path[i], 5, Color(0, 1, 0))
		pass
	else:
		print("nuting to draw")
		pass

func _process(delta):
	current_path = Nav.get_simple_path(get_global_pos(), get_node("../../Player").get_global_pos())
	if current_path.size() > 0:
		hasPath = true
		update()
		set_axis_velocity(current_path.get(0))
		pass
	else:
		hasPath = false
		print("unable to path")
		pass
	pass

func _ready():
	Nav = get_node("/root/Root/Navigation2D")
	
	set_process(true)
	ImmunityTimer = get_node("ImmunityTimer")
	
	ImmunityTimer.set_one_shot(false)
	ImmunityTimer.set_wait_time((DamageImmuneTimeMS/1000.0)/5)
	ImmunityTimer.set_autostart(false)
	
	DamageImmuneTimer.set_one_shot(true)
	DamageImmuneTimer.set_wait_time(DamageImmuneTimeMS/1000.0)
	DamageImmuneTimer.set_autostart(false)
	add_child(DamageImmuneTimer)
	
	get_node("HP_Text").set_text(str(Hitpoints))
	
	DamageImmuneTimer.connect("timeout", self, "make_vulnerable")
	ImmunityTimer.connect("timeout", self, "flicker")
	
	connect("was_hit", self, "handle_hit_result")
	pass
	
func hit(Damage):
	if DamageImmuneTimer.get_time_left() > 0:
		return
	Hitpoints -= max(Damage-Armor, 0)
	get_node("HP_Text").set_text(str(Hitpoints))
	
	emit_signal("was_hit")
	pass

var flickerCount = 0
func handle_hit_result():
	if Hitpoints<=0:
		queue_free()
	else:
		DamageImmuneTimer.start()
		ImmunityTimer.start()
	
	pass

func make_vulnerable():
	ImmunityTimer.stop()
	get_node("Sprite").show()
	pass


func flicker():
	if get_node("Sprite").is_visible():
		get_node("Sprite").hide()
	else:
		get_node("Sprite").show()
	pass
