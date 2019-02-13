"""
HotbarPanelController

Holds meta information about hotbar slots and controls the hotbar selection square.
"""
extends Panel

const LABEL_COLOR = Color(0, 0, 0, 1)

export (Array) var _slots = []

func add_slot(slot):
	_slots.append(slot)
	$Grid.add_child(slot)
	
func add_labels():
	for slot in _slots:
		var hotbar_key_label = Label.new()
		slot.add_child(hotbar_key_label)
		hotbar_key_label.set("custom_colors/font_color", LABEL_COLOR)
	
	for slot in range(0, 9):
		_slots[slot].get_child(2).text = str(slot + 1)
	
	_slots[9].get_child(2).text = "0"
	_slots[10].get_child(2).text = "-"
	_slots[11].get_child(2).text = "="
	
func select_slot(index):
	$SelectionSquare.position = $Grid.get_child(index).get_rect().position + (get_parent().get_slot_selection_offset())
