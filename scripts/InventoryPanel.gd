"""
InventoryPanel

Holds the information for inventory slots
"""
extends Panel

export (Array) var _slots = []

func add_slot(slot):
	_slots.append(slot)
	$InventoryGrid.add_child(slot)