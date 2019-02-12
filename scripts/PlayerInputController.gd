"""
PlayerInputController

Controls the logic for player movement and uses actions provided from player.

Movement is acceleration-based.
Collisions for floor detection needed two raycasts for each side of the player
"""
extends Node

var Bullet = preload('res://scenes/entities/bullet.tscn')

var Player
onready var GLOBAL = get_node('/root/main/GlobalControllers/GameState')

export var maxSpeed = Vector2(600, 1000)
export var speed = Vector2(0, 0)
export var acceleration = 1000
export var deceleration = 2000
export var jumpForce = 800
export var velocity = Vector2()
export var direction = 1
export var input_direction = 0

func _ready():
	set_process(true)
	set_process_input(true)
	
	Player = get_parent()

func _load():
	Player.Inventory.select_slot(0)
	
func _input(event):
	if event.is_action_pressed("jump") and _isOnFloor():
		speed.y = -jumpForce
	
	if not Player.FlipTimer.is_stopped():
		if event.is_action_pressed("ui_left"):
			Player.force_flip(false)
		if event.is_action_pressed("ui_right"):
			Player.force_flip(true)
		
	if event.is_action_pressed("primaryFire"):
		var item = Player.Inventory.selectedItem
		
		if item._id > -1:
			Player.start_flip()
			if item._name == 'gun':
				Player.shoot()
			elif item._name == 'pick':
				Player.pick()
			else:
				print(item._name)

func _process(delta):
	pass

func _physics_process(delta):
	var collision = null

	_get_input(delta)

	# enable/disable gravity
	if Player.get_slide_count() != 0:
		for collider_index in range(0, Player.get_slide_count()):
			collision = Player.get_slide_collision(collider_index)
			if collision != null and collision.collider != null:
				if collision.collider.is_in_group("Items"):
					var item = collision.collider.pickup()
					print(item.count)
					Player.pickup(item)

	Player.move_and_slide(velocity, Vector2(0, -1), false, 4, 0.785398, false)


func _get_input(delta):
	# get previous direction
	if input_direction:
		direction = input_direction
		
	if Input.is_action_pressed('ui_right'):
		if Player.FlipTimer.is_stopped():
			Player.set_flip(true)
		input_direction = 1
	elif Input.is_action_pressed('ui_left'):
		if Player.FlipTimer.is_stopped():
			Player.set_flip(false)
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
	# bumps the head
	if Player.is_on_ceiling():
		velocity.y = 1
		speed.y = 1

func _processBody():
	pass

func _clampVector(speedVector, maxSpeedVector):
	var clampedVector = speedVector
	
	clampedVector.x = clamp(clampedVector.x, 0, maxSpeedVector.x)
	clampedVector.y = clamp(clampedVector.y, -jumpForce, maxSpeedVector.y)
	
	return clampedVector

func _isOnFloor():
	var colliderLeft = Player.RayCastLeft.get_collider()
	var colliderRight = Player.RayCastRight.get_collider()
	
	if colliderLeft != null or colliderRight != null:
		return true
	
	return false or Player.is_on_floor()