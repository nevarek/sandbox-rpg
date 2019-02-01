extends KinematicBody2D

onready var speed = 50

var velocity = Vector2()
var destination = Vector2()
var damage = 10

func _ready():
	position = Vector2()
	set_process(true)
	
func fire():
	velocity = (destination - position).normalized() * speed
	
func _physics_process(delta):
	var collision = move_and_collide(velocity)
	
	if collision != null and _shouldCollide(collision):
		queue_free()
		
		if _collisionHitEnemy(collision):
			var victim = collision.collider
			victim.applyDamage(damage)
	
	checkIfPastScreen()
		
func checkIfPastScreen():
	var screen = get_viewport_rect()
	
	if position.x > screen.size.x or position.x < 0 or position.y > screen.size.y or position.y < 0:
		queue_free()
		
func _shouldCollide(collision):
	return collision.collider.is_in_group("Enemy") or collision.collider.is_in_group("Environment")
	
func _collisionHitEnemy(collision):
	return collision.collider.is_in_group("Enemy")