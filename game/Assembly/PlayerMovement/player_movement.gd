
extends KinematicBody2D

const GRAVITY=9.81
var mv=Vector2()
export var MovementSpeed=1.0
export var JumpSpeed=1.0
var isColliding=false
var ColN = Vector2()
var AttackCD = Timer.new()

var attackInstance = load("res://Assembly/PlayerMovement/attack_sprite.scn")

const PlayerStates = {
	IDLE_STATE=0,
	WALK_STATE=1,
	RUN_STATE=2,
	ATTACK_STATE=3
}

signal enter_state(StateName)


# This does not work if using is_colliding() so close (_handleJump and following this line) -> unable to jump
func _handleJump():
	if(Input.is_action_pressed("ui_up")):
		if(isColliding):
			if(ColN.y < 0.3): # proper ground check
				mv.y = -JumpSpeed
				isColliding = false

func _fixed_process(delta):
	# Storing the first request works fine though, but asking twice per frame - simply blocks jump
	isColliding = is_colliding()
	if(isColliding):
		ColN = get_collision_normal()
	
	mv.y += delta * GRAVITY
	
	if(Input.is_action_pressed("ui_left")):
		mv.x = -MovementSpeed
	elif( Input.is_action_pressed("ui_right")):
		mv.x = MovementSpeed
	else:
		mv.x = lerp(mv.x, 0.0, delta*3)

	_handleJump()
	
	var plannedMotion = move(mv)
	if(isColliding):
		plannedMotion = ColN.slide(plannedMotion)
		mv = ColN.slide(mv)
		move(plannedMotion)
	pass

func _ready():
	# Initialization here
	set_fixed_process(true)
	set_process_input(true)
	
	AttackCD.set_one_shot(true)
	AttackCD.set_autostart(false)
	AttackCD.set_wait_time(0.5)
	self.add_child(AttackCD)
	
	pass

func attack():
	AttackCD.start()
	var node = attackInstance.instance()
	var offset = 14.0
	if get_node("Sprite").is_flipped_h():
		offset *= -1
		
	node.set_pos( get_global_pos() + Vector2(offset, 0) )
	node.get_node("Sprite").set_flip_h(get_node("Sprite").is_flipped_h())

	get_node("/root/").add_child(node)
	

func _input(event):
	if event.is_action("attack") && event.is_pressed() && !event.is_echo() && !(AttackCD.get_time_left() > 0.0):
		emit_signal("enter_state", PlayerStates.ATTACK_STATE)
		attack()
	pass
	
