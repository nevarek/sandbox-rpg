extends KinematicBody2D

onready var Player = get_node('/root/main/Player')

onready var speed = 50

var velocity = Vector2()
var destination = Vector2()
export var damage = 10
export var origin = Vector2()

export var MAX_DISTANCE_FROM_ORIGIN = 100000
export var MAX_DISTANCE_FROM_PLAYER = 10000

func _ready():
	position = Vector2()
	set_process(true)
	
func fire():
	origin = position
	velocity = (destination - position).normalized() * speed
	
func _physics_process(delta):
	var collision = move_and_collide(velocity)
	
	if collision != null and _shouldCollide(collision):
		queue_free()
		
		if _collisionHitEnemy(collision):
			var victim = collision.collider
			victim.applyDamage(damage)
	
	checkIfShouldDespawn()
		
func checkIfShouldDespawn():
	var distanceFromPlayer = (Player.position - position).length()
	var distanceFromOrigin = (origin - position).length()
	
	if distanceFromPlayer > MAX_DISTANCE_FROM_PLAYER or distanceFromOrigin > MAX_DISTANCE_FROM_ORIGIN:
		queue_free()
		
func _shouldCollide(collision):
	return collision.collider.is_in_group("Enemy") or collision.collider.is_in_group("Environment")
	
func _collisionHitEnemy(collision):
	return collision.collider.is_in_group("Enemy")