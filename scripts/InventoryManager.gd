"""
Inventory (Control)

Handles control logic for all inventory.

All inventory is on the same array, but the array is sliced to separate the hotbar and main inventory.
This is for auto-arraging the grids, so the item logic should be handled here instead of the associated GUI container.
"""
extends Control

const SLOT_SIZE = Vector2(32, 32)
var InventorySlotScene = preload('res://scenes/InventorySlot.tscn')

onready var HotbarPanel = get_child(0)
onready var InventoryPanel = get_child(1)
onready var Player = get_node("/root/main/Player")

export (Array) var slots = []

func _ready():
	for slot_index in range(0, 72):
		# slot_index used to count only
		var new_slot = InventorySlotScene.instance()
		slots.append(new_slot)
	
	# Hotbar slice
	for slot_index in range(0, 12):
		HotbarPanel.add_slot(slots[slot_index])
		
	HotbarPanel.add_labels()
	
	# Main inventory slice
	for slot_index in range(12, 72):
		InventoryPanel.add_slot(slots[slot_index])
		
	select_slot(0)

func toggle_inventory_view():
	InventoryPanel.visible = !InventoryPanel.visible

func set_inventory_view(visibility):
	InventoryPanel.get_canvas_item().visibility = visibility

func select_slot(slot_index):
	HotbarPanel.select_slot(slot_index)
	
func get_slot_selection_offset():
	# Returns slot offset for selection square (and any others)
	return SLOT_SIZE / 8

func get_item_list():
	return Player.Inventory.item_list