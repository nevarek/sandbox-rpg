"""
InventoryInputController

Input handling for hotbar and rest of inventory
"""

extends Node

var Player

func _ready():
	Player = get_node('/root/main/Player')
	
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("hotbar_1"):
		selectItem(0)
	
	if event.is_action_pressed("hotbar_2"):
		selectItem(1)
		
func selectItem(inventoryIndex):
	Player.selectedSlot = {
		name = Player.Inventory[inventoryIndex], 
		index = inventoryIndex
	}