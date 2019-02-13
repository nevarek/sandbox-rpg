extends Node

onready var Main = get_node('/root/main')
onready var InventoryManager = get_node('/root/main/UI/Inventory')

var ItemScene = preload('res://scenes/entities/Item.tscn')
var tile_size = Vector2(32, 32)

var item_list

func _ready():
	pass
	
func drop_item(item_info, location):
	var newitem = ItemScene.instance()
	var spawn_position = location + ( tile_size / 2 )
	newitem.spawn(Main, spawn_position, item_info)
	
func get_item_list():
	if item_list.size() > 0:
		return item_list
	else:
		item_list = InventoryManager.item_list

