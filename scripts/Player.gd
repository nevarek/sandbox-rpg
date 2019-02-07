"""
Player

Controls the logic for player movement and actions.

Movement is acceleration-based.
Collisions for floor detection needed two raycasts for each side of the player
"""

extends KinematicBody2D
const Bullet = preload('res://scenes/entities/bullet.tscn')

var Tilemap
var Inventory
var RayCastLeft
var RayCastRight
var FlipTimer
var _sprite

func _ready():
	Tilemap = get_node('/root/main/TileMap')
	Inventory = $Inventory
	print(Inventory)
	
	RayCastLeft = $RayCast_Floor_Left
	RayCastRight = $RayCast_Floor_Right
	
	FlipTimer = $FlipTimer
	_sprite = $Sprite
	
	$BulletSpawnLocation.position = position
	
	$PlayerInputController._load()

func shoot():
	var bullet = Bullet.instance()
	var target = get_global_mouse_position()
	
	if $Cooldown.is_stopped() || true:
		_faceTarget(target)
		
		$Cooldown.start()
		
		get_parent().add_child(bullet)
		
		bullet.fire(self, target)
		
func pick():
	var target = get_global_mouse_position()
	_faceTarget(target)
	
	var tile_index = Tilemap.world_to_map(target)
	Tilemap.hit_tile(tile_index, 5)
	
func pickup(item_info):
	print(item_info)
	
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
	
func force_flip(value = null):
	if value == null:
		$Sprite.flip_h = !$Sprite.flip_h
	else:
		$Sprite.flip_h = value
		$FlipTimer.stop()
	
func set_flip(value):
	$Sprite.flip_h = value
	
func start_flip():
	$FlipTimer.start()