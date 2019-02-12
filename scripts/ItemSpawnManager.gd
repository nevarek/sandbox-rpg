extends Node

onready var Main = get_node('/root/main')
onready var Player = get_node('/root/main/Player')
var ItemScene = preload('res://scenes/entities/Item.tscn')
var tile_size = Vector2(32, 32)

var ItemTextures = [
	null,
	preload("res://assets/items/dirt.png"),
	preload("res://assets/items/stone.png")
]

export (Array) var items = [
	{
		_name = null,
		_id = -1,
		"texture": null
	},
	{
		_name = 'dirt',
		_id = 1,
		"texture": ItemTextures[1]
	},
	{
		_name = 'stone',
		_id = 2,
		"texture": ItemTextures[2]
	}
]

func _ready():
	pass
	
func drop_item(item_info, location):
	var newitem = ItemScene.instance()
	var spawn_position = location + ( tile_size / 2 )
	newitem.spawn(Main, spawn_position, item_info)

