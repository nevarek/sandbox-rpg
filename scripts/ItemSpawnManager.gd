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
		itemname = 'trash',
		itemid = 0,
		"texture": ItemTextures[0]
	},
	{
		itemname = 'dirt',
		itemid = 1,
		"texture": ItemTextures[1]
	},
	{
		itemname = 'stone',
		itemid = 2,
		"texture": ItemTextures[2]
	}
]

func _ready():
	pass
	
func drop_item(item_info, spawn_position):
	var newitem = ItemScene.instance()
	newitem.position = spawn_position + ( tile_size / 2 )
	newitem.get_child(0).texture = item_info.texture
	newitem.spawn(Main)

