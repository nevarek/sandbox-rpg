extends KinematicBody2D
var Bullet = preload('res://scenes/entities/bullet.tscn')
	
onready var HotbarPanel = get_node('/root/main/CanvasLayer/UI/HotbarPanel')
onready var GLOBAL = get_node('/root/main/GlobalControllers/GameState')

export var maxSpeed = Vector2(600, 1000)
export var speed = Vector2(0, 0)
export var acceleration = 1000
export var deceleration = 2000
export var jumpForce = 800
export var velocity = Vector2()
export var direction = 1
export var input_direction = 0

export var selectedSlot = {
	"index": 0,
	"name": '<UNNAMED>'
}

export var Inventory = {
	0: 'pick',
	1: 'gun'
}


func _ready():
	$BulletSpawnLocation.position = position
	set_process(true)
	set_process_input(true)
	
	selectedSlot.name = Inventory[0]
	selectedSlot.index = 0
	
func _input(event):	
	if event.is_action_pressed("jump") and _isOnFloor():
		speed.y = -jumpForce
		
	if event.is_action_pressed("primaryFire"):
		$FlipTimer.start()
		if selectedSlot.name == 'gun':
			shoot()
		else:
			print(selectedSlot.name)

func _process(delta):
	HotbarPanel.setSelectionToIndex(selectedSlot.index)

func _physics_process(delta):
	var collision = null

	_processBody()
	_get_input(delta)

	# enable/disable gravity
	if get_slide_count() != 0:
		collision = get_slide_collision(0)
		collision.collider.is_in_group("Environment")

	move_and_slide(velocity, Vector2(0, -1))
	

func _get_input(delta):
	# get previous direction
	if input_direction:
		direction = input_direction
		
	if Input.is_action_pressed('ui_right'):
		if $FlipTimer.is_stopped():
			$Sprite.flip_h = true
		input_direction = 1
	elif Input.is_action_pressed('ui_left'):
		if $FlipTimer.is_stopped():
			$Sprite.flip_h = false
		input_direction = -1
	else:
		input_direction = 0
	
	# input processing
	if input_direction == -direction:
		speed.x /= 3
	if input_direction:
		speed.x += acceleration * delta
	else:
		speed.x -= deceleration * delta

	speed.y += GLOBAL.GRAVITY * delta
		
	speed = _clampVector(speed, maxSpeed)

	velocity.x = direction * speed.x
	velocity.y = speed.y

	# Unsticks from floor when jumping. This is due to a constant velocity due to gravity
	if Input.is_action_just_pressed("jump") and _isOnFloor() and velocity.y > 0:
		velocity.y = 0

func _processBody():
	$BulletSpawnLocation.position = position

func _clampVector(speedVector, maxSpeedVector):
	var clampedVector = speedVector
	
	clampedVector.x = clamp(clampedVector.x, 0, maxSpeedVector.x)
	clampedVector.y = clamp(clampedVector.y, -jumpForce, maxSpeedVector.y)
	
	return clampedVector

func _faceTarget(target):
	var orientation
	
	if $Sprite.flip_h:
		orientation = target - position
	else:
		orientation = position - target

	if orientation.x < 0:
		_flipBody()

func _flipBody():
	$FlipTimer.start()
	$Sprite.flip_h = !$Sprite.flip_h

func _isOnFloor():
	var colliderLeft = $RayCast_Floor_Left.get_collider()
	var colliderRight = $RayCast_Floor_Right.get_collider()
	
	if colliderLeft != null or colliderRight != null:
		return true
	
	return false or is_on_floor()


func shoot():
	var bullet = Bullet.instance()
	var target = get_global_mouse_position()
	
	if $Cooldown.is_stopped() || true:
		var y = _faceTarget(target)
		
		$Cooldown.start()
		
		get_parent().add_child(bullet)
		
		bullet.position = $BulletSpawnLocation.position
		bullet.destination = target
		
		bullet.fire()