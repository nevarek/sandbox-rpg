"""
Inventory

Controls the logic for inventory management and slot selection.

Interacts with the hotbar in order to visually represent changes.

# TODO refactor to import items (maybe their texture refs in there too) into a file instead of statically declaring here #refactor
# TODO refactor hotbar into this inventory manager, extend inventory by the 12 slots OR create a separate hotbar inventory #refactor
"""

extends Node

const NULL_ITEM = {
	"_name": null,
	"_id": -1,
	"texture": null,
	"count": -1
}

var Player

const item_textures = [
	preload('res://assets/items/dirt.png'),
	preload('res://assets/items/stone.png'),
	preload('res://assets/items/gun.png'),
	preload('res://assets/items/pick.png')
]

const MAX_ITEM_STACK = 1000

export var item_list = Array()
export var slots = Array()

export var selectedItem = Dictionary()
export var selectedSlot = -1

onready var Items = {
	0: NULL_ITEM,
	1: {
		"_id": 1,
		"_name": 'dirt',
		"texture": item_textures[0]
	},
	2: {
		"_id": 2,
		"_name": 'gun',
		"texture": item_textures[2]
	},
	3: {
		"_id": 3,
		"_name": 'pick',
		"texture": item_textures[3]
	}
}

func _ready():
	# NOTE: Bug in setting new arrays. Reference for slots and item_list were the same???
	# Fix here was to re-set the arrays
	item_list = Array()
	slots = get_node('/root/main/CanvasLayer/UI/InventoryPanel/InventoryGrid').slots
	
	_init_slots()
	_load_item_list()
	
	set_item(1, item_list[2])
	set_item(2, item_list[3])
	
	Player = get_node('/root/main/Player')
	
	set_process_input(true)

func init():
	select_slot(0)
	
func _init_slots():
	pass

func get_item_in_slot(index):
	print('getting item in slot index %d' % index)
	var item_info = NULL_ITEM
	
	print(slots)
	
	if slots.size() > 0 and slots[index].item != NULL_ITEM:
		item_info = slots[index].item
		print("item info for slot: %s" % str(item_info))
	
	return item_info
	
func get_selected_item():
	return get_item_in_slot(selectedSlot)
	
func select_slot(index):
	selectedItem = get_item_in_slot(index)
	selectedSlot = index
	
func _load_item_list():
	for item_index in Items:
		item_list.append(Items[item_index])

func add_item(item_info, count = 1):
	print('adding item', str(item_info))
	var existing_items = get_item_stacks(item_info)
	
	if existing_items.size() > 0:
		_apply_items_to_existing(existing_items, count)
	else:
		var itemObject = get_next_empty()
		var new_item_info = {
			
		}
		itemObject.item = item_info
		itemObject.item.count = count
		
func set_item(index, item_info, count = 1):
	print('setting item %s' % str(item_info))
	slots[index].item = item_info
	slots[index].item.count = count

func get_item_stacks(item_info):
	var existing_item_indicies = []
	
	for itemObject in slots:
		if itemObject.item._id != -1 and itemObject.item._name == item_info._name:
			existing_item_indicies.append(itemObject)
			
	return existing_item_indicies
	
func _apply_items_to_existing(existing_items, count):
	for itemObject in existing_items:
		print(itemObject.item._name)
#		if item.count < MAX_ITEM_STACK:
#			print(item.count)
#			return
		
func get_next_empty():
	for itemObject in slots:
		if itemObject.item._id == -1:
			return itemObject
			
	return null
	
func has_item(item_info):
	return get_item_stacks(item_info).size() > 0