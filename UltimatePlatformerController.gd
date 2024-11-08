extends CharacterBody2D

class_name PlatformerController2D

@export_category("Necesary Child Nodes")
@export var PlayerSprite: AnimatedSprite2D
@export var PlayerCollider: CollisionShape2D

##The max speed your player will move
var maxSpeed: float = 200.0
##How fast your player will reach max speed from rest (in seconds)
var timeToReachMaxSpeed: float = 0.2
##How fast your player will reach zero speed from max speed (in seconds)
var timeToReachZeroSpeed: float = 0.2


#INFO JUMPING 
@export_category("Jumping and Gravity")
#Max jump height
var jumpHeight: float = 3.0
#Max jumps, including grounded jump
var jumps: int = 2
#Gravity strength
var gravityScale: float = 20.0
#Fastest falling speed
var terminalVelocity: float = 500.0
#Gravity increase when falling
var descendingGravityFactor: float = 1.3
#Short hops
var shortHop: bool = true
#Time to jump after falling off a ledge
var coyoteTime: float = 0.2
##The window of time (in seconds) that your player can press the jump button before hitting the ground and still have their input registered as a jump. This is set to 0.2 seconds by default.
@export_range(0, 0.5) var jumpBuffering: float = 0.2




#Variables determined by the developer set ones.
var appliedGravity: float
var appliedTerminalVelocity: float

var friction: float
var acceleration: float
var deceleration: float
var instantAccel: bool = false
var instantStop: bool = false

var jumpMagnitude: float = 500.0
var jumpCount: int
var jumpWasPressed: bool = false
var coyoteActive: bool = false
var dashMagnitude: float
var gravityActive: bool = true

var wasMovingR: bool
var wasPressingR: bool
var movementInputMonitoring: Vector2 = Vector2(true, true) #movementInputMonitoring.x addresses right direction while .y addresses left direction

var gdelta: float = 1

var dset = false

var colliderScaleLockY
var colliderPosLockY

var anim
var col
var animScaleLock : Vector2

var timerStarted = false

#Input Variables for the whole script
var upHold
var downHold
var leftHold
var leftTap
var leftRelease
var rightHold
var rightTap
var rightRelease
var jumpTap
var jumpRelease
var runHold
var latchHold
var dashTap
var rollTap
var downTap
var twirlTap

func _ready():
	wasMovingR = true
	anim = PlayerSprite
	col = PlayerCollider
	
	_updateData()
	
func _updateData():
	acceleration = maxSpeed / timeToReachMaxSpeed
	deceleration = -maxSpeed / timeToReachZeroSpeed
	
	jumpMagnitude = (10.0 * jumpHeight) * gravityScale
	jumpCount = jumps
	
	animScaleLock = abs(anim.scale)
	colliderScaleLockY = col.scale.y
	colliderPosLockY = col.position.y
	
	if timeToReachMaxSpeed == 0:
		instantAccel = true
		timeToReachMaxSpeed = 1
	elif timeToReachMaxSpeed < 0:
		timeToReachMaxSpeed = abs(timeToReachMaxSpeed)
		instantAccel = false
	else:
		instantAccel = false
		
	if timeToReachZeroSpeed == 0:
		instantStop = true
		timeToReachZeroSpeed = 1
	elif timeToReachMaxSpeed < 0:
		timeToReachMaxSpeed = abs(timeToReachMaxSpeed)
		instantStop = false
	else:
		instantStop = false
		
	if jumps > 1:
		jumpBuffering = 0
		coyoteTime = 0
	
	coyoteTime = abs(coyoteTime)
	jumpBuffering = abs(jumpBuffering)
	
	

func _process(_delta):
	#Flip Sprite
	if rightHold:
		anim.scale.x = animScaleLock.x
	if leftHold:
		anim.scale.x = animScaleLock.x * -1
	
	#Movement
	if abs(velocity.x) > 0.1 and is_on_floor() and !is_on_wall():
		if !timerStarted:
			timerStarted = true
			var node = get_node("../CanvasLayer/SpeedrunTimer")
			node.start_timer()
		anim.speed_scale = abs(velocity.x / 150)
		anim.play("run")
	elif abs(velocity.x) < 0.1 and is_on_floor():
		anim.speed_scale = 1
		anim.play("idle")

	#Jumping
	if velocity.y < 0:
		if !timerStarted:
			timerStarted = true
			var node = get_node("../CanvasLayer/SpeedrunTimer")
			node.start_timer()
		anim.speed_scale = 1
		anim.play("jump")

	#Falling
	if velocity.y > 40:
		anim.speed_scale = 1
		anim.play("falling")
		
		
		

func _physics_process(delta):
	if !dset:
		gdelta = delta
		dset = true
	#INFO Input Detectio. Define your inputs from the project settings here.
	leftHold = Input.is_action_pressed("left")
	rightHold = Input.is_action_pressed("right")
	upHold = Input.is_action_pressed("up")
	leftTap = Input.is_action_just_pressed("left")
	rightTap = Input.is_action_just_pressed("right")
	leftRelease = Input.is_action_just_released("left")
	rightRelease = Input.is_action_just_released("right")
	jumpTap = Input.is_action_just_pressed("jump")
	jumpRelease = Input.is_action_just_released("jump")
	
	
	#INFO Left and Right Movement
	
	if rightHold and leftHold and movementInputMonitoring:
		if !instantStop:
			_decelerate(delta, false)
		else:
			velocity.x = -0.1
	elif rightHold and movementInputMonitoring.x:
		if velocity.x > maxSpeed or instantAccel:
			velocity.x = maxSpeed
		else:
			velocity.x += acceleration * delta
		if velocity.x < 0:
			if !instantStop:
				_decelerate(delta, false)
			else:
				velocity.x = -0.1
	elif leftHold and movementInputMonitoring.y:
		if velocity.x < -maxSpeed or instantAccel:
			velocity.x = -maxSpeed
		else:
			velocity.x -= acceleration * delta
		if velocity.x > 0:
			if !instantStop:
				_decelerate(delta, false)
			else:
				velocity.x = 0.1
				
	if velocity.x > 0:
		wasMovingR = true
	elif velocity.x < 0:
		wasMovingR = false
		
	if rightTap:
		wasPressingR = true
	if leftTap:
		wasPressingR = false
	
	if !(leftHold or rightHold):
		if !instantStop:
			_decelerate(delta, false)
		else:
			velocity.x = 0

	col.scale.y = colliderScaleLockY
	col.position.y = colliderPosLockY
			
	#INFO Jump and Gravity
	if velocity.y > 0:
		appliedGravity = gravityScale * descendingGravityFactor
	else:
		appliedGravity = gravityScale

	
	if gravityActive:
		if velocity.y < terminalVelocity:
			velocity.y += appliedGravity
		elif velocity.y > terminalVelocity:
				velocity.y = terminalVelocity
		
	if shortHop and jumpRelease and velocity.y < 0:
		velocity.y = velocity.y / 2
	
	if jumps == 1:
		if !is_on_floor() and !is_on_wall():
			if coyoteTime > 0:
				coyoteActive = true
				_coyoteTime()		
		if jumpTap and !is_on_wall():
			if coyoteActive:
				coyoteActive = false
				_jump()
			if jumpBuffering > 0:
				jumpWasPressed = true
				_bufferJump()
			elif jumpBuffering == 0 and coyoteTime == 0 and is_on_floor():
				_jump()	
		elif jumpTap and is_on_floor():
			_jump()
		
		
			
		if is_on_floor():
			jumpCount = jumps
			coyoteActive = true
			if jumpWasPressed:
				_jump()

	elif jumps > 1:
		if is_on_floor():
			jumpCount = jumps
		elif jumpCount == jumps:
			jumpCount = jumps - 1
		if jumpTap and jumpCount > 0:
			velocity.y = -jumpMagnitude
			jumpCount = jumpCount - 1
	move_and_slide()
	
func _bufferJump():
	await get_tree().create_timer(jumpBuffering).timeout
	jumpWasPressed = false

func _coyoteTime():
	await get_tree().create_timer(coyoteTime).timeout
	coyoteActive = false
	jumpCount += -1

	
func _jump():
	if jumpCount > 0:
		velocity.y = -jumpMagnitude
		jumpCount += -1
		jumpWasPressed = false


func _inputPauseReset(time):
	await get_tree().create_timer(time).timeout
	movementInputMonitoring = Vector2(true, true)
	

func _decelerate(delta, vertical):
	if !vertical:
		if velocity.x > 0:
			velocity.x += deceleration * delta
		elif velocity.x < 0:
			velocity.x -= deceleration * delta
	elif vertical and velocity.y > 0:
		velocity.y += deceleration * delta


func _pauseGravity(time):
	gravityActive = false
	await get_tree().create_timer(time).timeout
	gravityActive = true

func _placeHolder():
	print("")
