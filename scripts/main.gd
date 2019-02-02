extends Node2D

var EnemyScene = preload('res://scenes/entities/Enemy.tscn')

onready var Player = $Player
onready var EnemySpawnTimer = $GlobalControllers/EnemySpawnTimer
onready var PlayerCamera = $Player/PlayerCamera

func _ready():
	$CanvasLayer/UI/HotbarPanel.setSelectionToIndex(0)
	randomize()
	PlayerCamera.make_current()

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