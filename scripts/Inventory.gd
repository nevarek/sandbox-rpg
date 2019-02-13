"""
Inventory (Player)

Controls the logic for inventory management and slot selection.

Interacts with the hotbar in order to visually represent changes.

# TODO refactor to import items (maybe their texture refs in there too) into a file instead of statically declaring here #refactor #1
# TODO refactor hotbar into this inventory manager, extend inventory by the 12 slots OR create a separate hotbar inventory #refactor #2
"""

extends Node

const ITEM_TEXTURE_PATH_PREFIX = "res://assets/items/"

var NULL_ITEM = {}

var item_textures = []

const MAX_ITEM_STACK = 1000

export var item_list = Array()
export var slots = Array()

export var selectedItem = Dictionary()
export var selectedSlot = -1

var Items = {}

func _ready():
	# NOTE: Bug in setting new arrays. Reference for slots and item_list were the same???
	# Fix here was to re-set the arrays
	item_list = Array()
	slots = get_node('/root/main/CanvasLayer/UI/Inventory').slots
	
	_load_item_list()
	_load_item_textures()
	
	NULL_ITEM = item_list[0]
	
	set_item_in_slot(1, item_list[2])
	set_item_in_slot(2, item_list[3])
	
	set_process_input(true)

func _load_item_textures():
	var item_texture_path
	
	for item in item_list:
		item_texture_path = ITEM_TEXTURE_PATH_PREFIX + str(item.texture_ref)
		var texture = load(item_texture_path)
		item_textures.append(texture)
		item.texture_ref = texture

func _load_json_information(path):
	var result
	
	var file = File.new()
	
	if !file.file_exists(path):
		push_error("[Inventory] Error occurred opening file \"%s\"" % path)
		
	result = file.open(path, File.READ)
	
	var content = file.get_as_text()
	file.close()
	
	result = JSON.parse(content)
	if result.error != OK:
		push_error("[Inventory] Error occurred parsing JSON file")
	
	return result.result

func init():
	select_slot(0)

func get_item_in_slot(index):
	print('getting item in slot index %d' % index)
	var item_info = NULL_ITEM
	
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
	Items = _load_json_information("res://data/items.json")
	for item_index in Items:
		item_list.append(Items[item_index])

func add_item(item_info, count = 1):
	print('adding item', str(item_info))
	var existing_items = get_item_stacks(item_info)
	
	if existing_items.size() > 0:
		_apply_items_to_existing(existing_items, count)
	else:
		var itemObject = get_next_empty()
		var new_item_info = item_info
		new_item_info.count = count
		
		itemObject.set_item(new_item_info)
		
func set_item_in_slot(index, item_info, count = 1):
	item_info.count = count
	print('setting item %s' % str(item_info))
	slots[index].set_item(item_info)
	

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