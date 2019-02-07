"""
Main

Controls the logic for managing the multiple parts of the project.

NOTE this may contain logic that needs to be refactored later.
"""
extends Node2D

var EnemyScene = preload('res://scenes/entities/Enemy.tscn')

onready var Player = $Player
onready var EnemySpawnTimer = $GlobalControllers/EnemySpawnTimer
onready var PlayerCamera = $Player/PlayerCamera

func _ready():
	$CanvasLayer/UI/HotbarPanel.select_slot(Player.Inventory.selectedSlot)
	randomize()
	PlayerCamera.make_current()

func _input(event):
	# DEBUG: Spawn enemy: Press Z
	if event.is_action_pressed("spawn"):
		spawnNewEnemy()


func _process(delta):
	pass
#	if EnemySpawnTimer.is_stopped():
#		EnemySpawnTimer.start()
#		spawnNewEnemy()


func spawnNewEnemy():
	"""
	Attempts to spawn a new enemy within a range of the player.
	
	Should probably create a player spawn radius instead.
	"""
	"""
	TODO Raycast to nearest spawnable ground and spawn there, instead of inside stuff
	"""
	var newEnemy
	newEnemy = EnemyScene.instance()
	
	# the jankiest do-while implementation ever
	newEnemy.position.x = rand_range(0, get_viewport_rect().size.x)
	newEnemy.position.y = rand_range(0, get_viewport_rect().size.y)
	
	var enemyDistanceFromPlayer = (newEnemy.position - Player.position).length()
	while enemyDistanceFromPlayer < 5:
		newEnemy.position.x = rand_range(0, get_viewport_rect().size.x)
		newEnemy.position.y = rand_range(0, get_viewport_rect().size.y)

	add_child(newEnemy)