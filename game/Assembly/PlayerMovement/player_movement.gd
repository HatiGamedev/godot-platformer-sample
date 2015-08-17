
extends KinematicBody2D

const GRAVITY=9.81
var mv=Vector2()
export var MovementSpeed=1.0
export var JumpSpeed=1.0
var isColliding=false
var ColN = Vector2()
var AttackCD = Timer.new()

var attackInstance = load("res://Assembly/PlayerMovement/attack_sprite.scn")

# Basically makes it static, so player does not have to be instanced
const PlayerState = {
	Idle="idle",
	Walk="walk",
	Run="run",
	Attack="attack",
	JumpStart="jump_start",
	Falling="jump_end",
	Landing="landing",
}

signal enter_state(StateName)
var CurrentState = PlayerState.Idle

var isGrounded
var groundRay

# This does not work if using is_colliding() so close (_handleJump and following this line) -> unable to jump
func _handleJump():
	if(Input.is_action_pressed("ui_up")):
		if(isColliding):
			if(ColN.y < 0.3): # proper ground check
				mv.y = -JumpSpeed
				isColliding = false
				emit_signal("enter_state", PlayerState.JumpStart)

var prevIsColliding # ugly hack

var PreviousState

func _fixed_process(delta):
	prevIsColliding = isColliding
	# Storing the first request works fine though, but asking twice per frame - simply blocks jump
	isColliding = is_colliding()
	isGrounded = groundRay.is_colliding()
	#print(isGrounded)
	
	if PreviousState != CurrentState:
		print(CurrentState)
		PreviousState = CurrentState
		pass

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
	
	if CurrentState == PlayerState.JumpStart || ( isColliding == false && prevIsColliding == isColliding ):
		if mv.y > 0.0:
			emit_signal("enter_state", PlayerState.Falling)
		pass
	
	var plannedMotion = move(mv)
	if(isColliding):
		if CurrentState == PlayerState.Falling:
			emit_signal("enter_state", PlayerState.Landing)
			pass
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
	
	groundRay = get_node("GroundRay")
	
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
		emit_signal("enter_state", PlayerState.Attack)
		attack()
	elif event.is_action("ui_right") || event.is_action("ui_left"):
		if event.is_pressed() && !event.is_echo():
			emit_signal("enter_state", PlayerState.Walk)
		elif !event.is_pressed():
			emit_signal("enter_state", PlayerState.Idle)
		pass
	pass
	
func _on_Player_enter_state( StateName ):
	CurrentState = StateName
	pass # replace with function body


func _on_AnimationPlayer_animation_changed( old_name, new_name ):
	CurrentState = new_name
	pass # replace with function body
