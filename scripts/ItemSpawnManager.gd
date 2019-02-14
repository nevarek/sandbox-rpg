"""
ItemSpawnManager

Spawns items into the main scene when given item info and location.
"""
extends Node

onready var Main = get_node('/root/main')

var ItemScene = preload('res://scenes/entities/Item.tscn')
var tile_size = Vector2(32, 32)

func _ready():
	pass
	
func drop_item(item_info, location):
	var newitem = ItemScene.instance()
	var spawn_position = location + ( tile_size / 2 )
	newitem.spawn(Main, spawn_position, item_info)

