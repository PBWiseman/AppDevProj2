extends CharacterBody2D

class_name PlatformerController2D

@export_category("Necesary Child Nodes")
@export var PlayerSprite: AnimatedSprite2D
@export var PlayerCollider: CollisionShape2D

##The max speed your player will move
var maxSpeed: float = 200.0
#Time to reach max acceleration and deceleration
var timeToReach: float = 0.2

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




#Variables determined by the developer set ones.
var appliedGravity: float
var appliedTerminalVelocity: float

var friction: float
var acceleration: float
var deceleration: float

var jumpMagnitude: float = 500.0
var jumpCount: int
var jumpWasPressed: bool = false
var coyoteActive: bool = false
var gravityActive: bool = true

var wasMovingR: bool = true
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
var leftHold
var leftTap
var leftRelease
var rightHold
var rightTap
var rightRelease
var jumpTap
var jumpRelease

func _ready():
	anim = PlayerSprite
	col = PlayerCollider
	
	_updateData()
	
func _updateData():
	acceleration = maxSpeed / timeToReach
	deceleration = -maxSpeed / timeToReach
	jumpMagnitude = (10.0 * jumpHeight) * gravityScale
	jumpCount = jumps
	animScaleLock = abs(anim.scale)
	colliderScaleLockY = col.scale.y
	colliderPosLockY = col.position.y
	
	

func _process(_delta):
	#Flip Sprite
	if rightHold:
		anim.scale.x = animScaleLock.x
	if leftHold:
		anim.scale.x = animScaleLock.x * -1
	
	#Movement
	if abs(velocity.x) > 0.1 and is_on_floor() and !is_on_wall():
		timerStart()
		anim.speed_scale = abs(velocity.x / 150)
		anim.play("run")
	elif abs(velocity.x) < 0.1 and is_on_floor():
		anim.speed_scale = 1
		anim.play("idle")

	#Jumping
	if velocity.y < 0:
		timerStart()
		anim.speed_scale = 1
		anim.play("jump")

	#Falling
	if velocity.y > 40:
		anim.speed_scale = 1
		anim.play("falling")
		
func timerStart():
	if !timerStarted:
		timerStarted = true
		var node = get_node("../CanvasLayer/SpeedrunTimer")
		node.start_timer()
		

func _physics_process(delta):
	if !dset:
		gdelta = delta
		dset = true

	leftHold = Input.is_action_pressed("left")
	rightHold = Input.is_action_pressed("right")
	upHold = Input.is_action_pressed("up")
	leftTap = Input.is_action_just_pressed("left")
	rightTap = Input.is_action_just_pressed("right")
	leftRelease = Input.is_action_just_released("left")
	rightRelease = Input.is_action_just_released("right")
	jumpTap = Input.is_action_just_pressed("jump")
	jumpRelease = Input.is_action_just_released("jump")
	
	
	#Left and Right Movement
	if rightHold and leftHold and movementInputMonitoring:
		_decelerate(delta, false)
	elif rightHold and movementInputMonitoring.x:
		if velocity.x > maxSpeed:
			velocity.x = maxSpeed
		else:
			velocity.x += acceleration * delta
		if velocity.x < 0:
			_decelerate(delta, false)
	elif leftHold and movementInputMonitoring.y:
		if velocity.x < -maxSpeed:
			velocity.x = -maxSpeed
		else:
			velocity.x -= acceleration * delta
		if velocity.x > 0:
			_decelerate(delta, false)
				
	if velocity.x > 0:
		wasMovingR = true
	elif velocity.x < 0:
		wasMovingR = false
		
	if rightTap:
		wasPressingR = true
	if leftTap:
		wasPressingR = false
	
	if !(leftHold or rightHold):
		_decelerate(delta, false)

	col.scale.y = colliderScaleLockY
	col.position.y = colliderPosLockY
			
	#Jump and Gravity
	if velocity.y > 0:
		appliedGravity = gravityScale * descendingGravityFactor
	else:
		appliedGravity = gravityScale

	
	if gravityActive:
		if velocity.y < terminalVelocity:
			velocity.y += appliedGravity
		elif velocity.y > terminalVelocity:
				velocity.y = terminalVelocity
		
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