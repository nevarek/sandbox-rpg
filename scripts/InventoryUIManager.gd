"""
InventoryUIManager

Handles visual logic for all the inventory UI

All inventory is on the same array, but the array is sliced to separate the hotbar and main inventory.
This is for auto-arraging the grids, so the item logic should be handled here instead of the associated GUI container.
"""
extends Control

const SLOT_DIMENSIONS = Vector2(32, 32)

onready var HotbarPanel = get_child(0)
onready var InventoryPanel = get_child(1)

var slots = []

func _ready():
	pass
	
func setup_slots(new_slots):
	slots = new_slots
	
	# Hotbar slice
	for slot_index in range(0, 12):
		HotbarPanel.add_slot(slots[slot_index])
		
	HotbarPanel.add_labels()
	
	# Main inventory slice
	for slot_index in range(12, 72):
		InventoryPanel.add_slot(slots[slot_index])

func toggle_inventory_view():
	InventoryPanel.visible = !InventoryPanel.visible

func set_inventory_view(visibility):
	InventoryPanel.get_canvas_item().visibility = visibility

func select_slot(slot_index):
	HotbarPanel.select_slot(slot_index)
	
func get_slot_selection_offset():
	# Returns slot offset for selection square (and any others) so that it is centered when offset by the amount
	return SLOT_DIMENSIONS / 8