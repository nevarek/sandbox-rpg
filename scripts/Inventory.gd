"""
Inventory (Player)

Controls the logic for inventory management and internal slot selection.
"""
extends Node

var InventorySlotScene = preload('res://scenes/InventorySlot.tscn')
onready var InventoryUI = get_node('/root/main/CanvasLayer/UI/Inventory')

var NULL_ITEM = {}
var MAX_ITEM_STACK = 1000

const NUMBER_OF_SLOTS = 72

export var item_list = Array()
export var slots = Array()

export var selectedItem = Dictionary()
export var selectedSlot = -1

func _ready():
	# NOTE: Bug in setting new arrays. Reference for slots and item_list were the same???
	# Fix here was to re-set the arrays
	item_list = ItemInformation.item_list
	MAX_ITEM_STACK = ItemInformation.MAX_ITEM_STACK
	NULL_ITEM = item_list[0]
	
	# wait until node tree is finished
	yield(get_tree(), "idle_frame")
	_init_slots()
	set_process_input(true)
	_startup()

func _init_slots():
	for slot_index in range(0, NUMBER_OF_SLOTS):
		# slot_index used to count only
		var new_slot = InventorySlotScene.instance()
		slots.append(new_slot)
	
	InventoryUI.setup_slots(slots)

func _startup():
	var gun_index = 3
	var pick_index = 4
	set_item_in_slot(1, item_list[gun_index])
	set_item_in_slot(2, item_list[pick_index])
	select_slot(0)

func get_item_in_slot(index):
	var item_info = NULL_ITEM
	
	if slots.size() > 0 and slots[index].item != NULL_ITEM:
		item_info = slots[index].item
	
	return item_info
	
func select_slot(index):
	selectedItem = get_item_in_slot(index)
	selectedSlot = index

func get_selected_item():
	return get_item_in_slot(selectedSlot)
	
func get_next_empty_slot():
	for itemObject in slots:
		if itemObject.is_empty():
			return itemObject
			
	return null

func has_item(item_info):
	return get_existing_item_slots(item_info).size() > 0
	
func get_existing_item_slots(item_info):
	var existing_item_indicies = []
	
	for itemObject in slots:
		if itemObject.item._id != -1 and itemObject.item._name == item_info._name:
			existing_item_indicies.append(itemObject)
	
	return existing_item_indicies
	
func get_available_slots(item_info):
	var available_item_indicies = []
	
	for itemObject in slots:
		var item = itemObject.item
		if item._id != -1 and item._name == item_info._name and item.count < item.max_stack:
			available_item_indicies.append(itemObject)
	
	if available_item_indicies.size() < 1:
		available_item_indicies = [get_next_empty_slot()]
		
	return available_item_indicies

func add_item(item_info):
	var remainder_item_info = item_info
	print("info " + str(remainder_item_info))
	
	print('adding item %s' % str(item_info))
	var available_slots = get_available_slots(item_info)
	
	if available_slots != null:
		for slot in available_slots:
			remainder_item_info = _apply_item_to(remainder_item_info, slot)
			
			if remainder_item_info.has("count") and remainder_item_info.count == 0:
				break

	while remainder_item_info.count > 0:
		print("remainder %s" % str(remainder_item_info))
		var new_slot = get_next_empty_slot()
		
		if new_slot != null:
			remainder_item_info = _apply_item_to(remainder_item_info, new_slot)
		else:
			break
				

func set_item_in_slot(index, item_info, count = 1):
	item_info.count = count
	slots[index].set_item(item_info)
	
func _apply_item_to(item_info, slot):
	var remainder
	
	remainder = slot.combine(item_info)
	
	return remainder
		