extends Node


onready var Main = get_node('/root/main')
onready var Player = get_node('/root/main/Player')
var DirtScene = preload('res://scenes/entities/Item.tscn')
var tile_size = Vector2(32, 32)

export (Array) var items = [
	{
		itemname = 'trash',
		itemid = 0
	},
	{
		itemname = 'dirt',
		itemid = 1,
		"scene": DirtScene
	}
]

func _ready():
	pass
	
func drop_item(item_info, spawn_position):
	print('<drop> %s:ID%d' % [item_info.itemname, item_info.itemid])
	
	var newitem = item_info.scene.instance()
	newitem.position = spawn_position + ( tile_size / 2 )
	newitem.spawn(Main)

