"""
Player

Controls the logic for player actions and stores player state. Also controls which direction a player is facing.
Exports Player's nodes for the controller to easily access
"""

extends KinematicBody2D
# TODO refactor bullet to a projectile spawner instead of $BulletSpawnLocation #refactor
const Bullet = preload('res://scenes/entities/bullet.tscn')

onready var Tilemap = get_node('/root/main/TileMap')
onready var InventoryManager = get_node('/root/main/CanvasLayer/UI/Inventory')

var Inventory
var RayCastLeft
var RayCastRight
var FlipTimer
var _sprite

func _ready():
	Inventory = $Inventory
	
	RayCastLeft = $RayCast_Floor_Left
	RayCastRight = $RayCast_Floor_Right
	
	FlipTimer = $FlipTimer
	_sprite = $Sprite
	
	yield(get_tree(), "idle_frame")
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
	Tilemap.hit_tile(tile_index, 10)
	
func pickup(item_info):
	$Inventory.add_item(item_info)
	
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