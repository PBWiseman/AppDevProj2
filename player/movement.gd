extends CharacterBody2D

class_name PlatformerController2D

##The max speed your player will move
var maxSpeed: float = 200.0
#Time to reach max acceleration and deceleration
var timeToReach: float = 0.2

#Max jumps, including grounded jump
var jumps: int = 2
#Gravity strength
var GRAVITY_SCALE: float = 20.0
#Fastest falling speed
var TERMINAL_VELOCITY: float = 500.0
#Gravity increase when falling
var descendingGravityFactor: float = 1.3

var appliedGravity: float
var acceleration: float
var deceleration: float

var jumpMagnitude: float
var jumpCount: int

var anim
var col
var animScaleLock : Vector2

var timerStarted = false

#Input Variables for the whole script
var leftHold
var rightHold

func _ready():
	anim = get_node("AnimatedSprite2D")
	col = get_node("CollisionShape2D")
	acceleration = maxSpeed / timeToReach
	deceleration = -maxSpeed / timeToReach
	jumpMagnitude = 30 * GRAVITY_SCALE
	jumpCount = jumps
	animScaleLock = abs(anim.scale)

func _process(_delta):
	#Flip Sprite
	if rightHold:
		anim.scale.x = animScaleLock.x
	if leftHold:
		anim.scale.x = animScaleLock.x * -1
	
	#Movement
	if abs(velocity.x) > 0.1 and is_on_floor() and !is_on_wall():
		anim.speed_scale = abs(velocity.x / 150)
		anim.play("run")
	elif abs(velocity.x) < 0.1 and is_on_floor():
		anim.speed_scale = 1
		anim.play("idle")

	#Jumping
	if velocity.y < 0:
		anim.speed_scale = 1
		anim.play("jump")
	elif velocity.y > 40:
		anim.speed_scale = 1
		anim.play("falling")

func _physics_process(delta):
	#Input Monitoring
	leftHold = Input.is_action_pressed("left")
	rightHold = Input.is_action_pressed("right")
	var jumpTap = Input.is_action_just_pressed("jump")
	var jumpRelease = Input.is_action_just_released("jump")

	#Start timer on first move
	if !timerStarted and (leftHold or rightHold or jumpTap):
		timerStarted = true
		get_node("../CanvasLayer/SpeedrunTimer").start_timer()

	
	#Left and Right Movement
	if rightHold and leftHold:
		_decelerate(delta, false)
	elif rightHold:
		if velocity.x > maxSpeed:
			velocity.x = maxSpeed
		else:
			velocity.x += acceleration * delta
		if velocity.x < 0:
			_decelerate(delta, false)
	elif leftHold:
		if velocity.x < -maxSpeed:
			velocity.x = -maxSpeed
		else:
			velocity.x -= acceleration * delta
		if velocity.x > 0:
			_decelerate(delta, false)
	
	if !(leftHold or rightHold):
		_decelerate(delta, false)
			
	#Jump and Gravity
	if velocity.y > 0:
		appliedGravity = GRAVITY_SCALE * descendingGravityFactor
	else:
		appliedGravity = GRAVITY_SCALE

	if velocity.y < TERMINAL_VELOCITY:
		velocity.y += appliedGravity
	elif velocity.y > TERMINAL_VELOCITY:
			velocity.y = TERMINAL_VELOCITY
		
	if jumpRelease and velocity.y < 0:
		velocity.y = velocity.y / 2
	
	if is_on_floor():
		jumpCount = jumps
	elif jumpCount == jumps:
		jumpCount = jumps - 1
	if jumpTap and jumpCount > 0:
		velocity.y = -jumpMagnitude
		jumpCount = jumpCount - 1
	move_and_slide()
	
func _decelerate(delta, vertical):
	if !vertical:
		if velocity.x > 0:
			velocity.x += deceleration * delta
		elif velocity.x < 0:
			velocity.x -= deceleration * delta
	elif vertical and velocity.y > 0:
		velocity.y += deceleration * delta