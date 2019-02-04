"""
Bullet

Manages bullet physics and firing process.
"""
extends KinematicBody2D

onready var Player = get_node('/root/main/Player')

export var speed = 50

var velocity = Vector2()
var destination = Vector2()
export var damage = 10
export var origin = Vector2()

export var MAX_DISTANCE_FROM_ORIGIN = 100000
export var MAX_DISTANCE_FROM_PLAYER = 10000

func _ready():
	set_process(true)
	
func fire(fromEntity, detinationTo):
	"""
	Sets the bullet's origin for despawn, sets destination, and applies immediate speed to a unit vector for direction.
	Position is determined by the calling parent's position.
	"""
	
	position = fromEntity.position
	origin = position
	destination = detinationTo
	velocity = (destination - position).normalized() * speed
	
func _physics_process(delta):
	"""
	1. Check collisions
	2. Check for distance despawn
	"""
	var collision = move_and_collide(velocity)
	
	if collision != null:
		checkCollisions(collision)

	checkIfShouldDespawn()

func checkCollisions(collision):
	if _shouldCollide(collision):
		"""
		Checks if the collision satisfies criterion to despawn
		"""
		queue_free()
		
		if _collisionHitEnemy(collision):
			var victim = collision.collider
			victim.applyDamage(damage)

func checkIfShouldDespawn():
	"""
	Checks if the bullet should despawn due to distance
	"""
	var distanceFromPlayer = (Player.position - position).length()
	var distanceFromOrigin = (origin - position).length()
	
	if distanceFromPlayer > MAX_DISTANCE_FROM_PLAYER or distanceFromOrigin > MAX_DISTANCE_FROM_ORIGIN:
		queue_free()
		
func _shouldCollide(collision):
	return collision.collider.is_in_group("Enemy") or collision.collider.is_in_group("Environment")
	
func _collisionHitEnemy(collision):
	return collision.collider.is_in_group("Enemy")