"""
InventorySlot

Controls the logic for an individual inventory slot.

It has an item variable that contains the item information, and a sprite to control its displayed texture.
"""
extends Control

const NULL_ITEM = {
	"_name": null,
	"_id": -1,
	"texture_ref": null,
	"count": -1
}

export (Dictionary) var item = NULL_ITEM

func _ready():
	item = NULL_ITEM

func set_item(item_info):
	item = NULL_ITEM
	
	print('set item to %s' % str(item_info))
	
	if not item_info.has("count") or item_info.count <= 0:
		item = _get_new_item(item_info, 1)
	else:
		item = item_info
		
	set_texture(item.texture_ref)
	return item

func _get_new_item(item_info, count = 0):
	var new_item = {
			"_name": item_info._name,
			"_id": item_info._id,
			"texture_ref": item_info.texture_ref
		}
		
	if not item_info.has("count"):
		if count <= 0:
			new_item = NULL_ITEM
		else:
			new_item.count = count
		
	return new_item

func add(item_info):
	if item.name == null:
		print('new item')
	else:
		print('do some math')
		
func get_item():
	return item

func set_texture(texture):
	print('setting texture')
	$SlotSprite.texture = texture
	
func is_empty():
	return item == NULL_ITEM

func _on_InventorySlot_gui_input(event):
	if event.as_text().find("InputEventMouseButton") >= 0 \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		print(item)
		return self
