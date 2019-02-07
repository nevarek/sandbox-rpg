"""
Inventory

Controls the logic for inventory management and slot selection.

Interacts with the hotbar in order to visually represent changes.

# TODO refactor to import items (maybe their texture refs in there too) into a file instead of statically declaring here #refactor
"""

extends Node

var Player

const item_textures = [
	preload('res://assets/items/dirt.png'),
	preload('res://assets/items/gun.png'),
	preload('res://assets/items/pick.png')
]

export var item_list = Array()
export var slots = Array()

export var selectedItem = Dictionary()
export var selectedSlot = -1

onready var Items = {
	0: {
		"itemid": 1,
		"itemname": 'dirt',
		"itemtexture": item_textures[0]
	},
	1: {
		"itemid": 2,
		"itemname": 'gun',
		"itemtexture": item_textures[1]
	},
	2: {
		"itemid": 3,
		"itemname": 'pick',
		"itemtexture": item_textures[2]
	}
}

func _ready():
	_load_item_list()
	slots.append(item_list[0])
	slots.append(item_list[1])
	slots.append(item_list[2])
	
	Player = get_node('/root/main/Player')
	
	set_process_input(true)

func init():
	select_slot(0)

func get_item_in_slot(index):
	var item_info = {
		"itemname": slots[index].itemname,
		"itemtexture" : slots[index].itemtexture,
		"count": -1
	}
	return item_info

func get_item_info_for_slot(index):
	return item_list[index]
	
func get_selected_item():
	return get_item_in_slot(selectedSlot)

func add_item(itemid, count):
	pass
	
func select_slot(index):
	selectedItem = get_item_in_slot(index)
	selectedSlot = index
	
func _load_item_list():
	for item_index in Items:
		item_list.append(Items[item_index])
