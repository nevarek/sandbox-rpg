extends KinematicBody2D

onready var GLOBAL = get_node('/root/main/GameState')
onready var speed = 100
onready var Player = get_node('/root/main/Player')
onready var MIN_DISTANCE = $Sprite.get_rect().size.x / 2

var target
var velocity
export var health = 10

func _ready():
	set_process(true)
	
func _target_player(player):
	velocity = Vector2()
	
	target = player.position
	
	var distanceToTarget = (target - position).length()
	
	if distanceToTarget > MIN_DISTANCE:
		velocity = (target - position).normalized() * speed
		
	
func _physics_process(delta):
	_target_player(Player)
	move_and_slide(velocity)
	
func applyDamage(damage):
	health -= damage
	
	if (health <= 0):
		queue_free()
	
