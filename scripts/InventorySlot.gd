"""
InventorySlot

Controls the logic for an individual inventory slot.

It has an item variable that contains the item information, and a sprite to control its displayed texture.
"""
extends Control

var NULL_ITEM

const MAX_ITEM_STACK = 5

export (Dictionary) var item = NULL_ITEM

func _ready():
	NULL_ITEM = ItemInformation.NULL_ITEM
	item = NULL_ITEM
	
func set_item(item_info):
	if not is_empty():
		print_debug("Warning: attempting to add new item, item is not empty")
	
	item = item_info
	
	if not item.has("count"):
		item.count = 1
		
	set_texture()
	_update_count_label()
	
	return item
	
func _update_count_label():
	if item.count > 1:
		$ItemCountLabel.text = str(item.count)

func combine(item_info):
	if is_empty():
		item = _get_new_item(item_info)
		
	var result = item_info.count + item.count
	
	if result > int(item.max_stack):
		item.count = int(item.max_stack)
		item_info.count = result - item.count
	else:
		item.count = result
		item_info.count = 0
	
	return item_info

func set_texture():
	$SlotSprite.texture = item.ui_texture_ref

func _get_new_item(item_info):
	var new_item = item_info
	new_item.count = 0
	
	return new_item
	
func is_empty():
	return item == NULL_ITEM

func _on_InventorySlot_gui_input(event):
	if event.as_text().find("InputEventMouseButton") >= 0 \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		if not is_empty():
			print(item)
		return self
