extends Node

var Player

func _ready():
	Player = get_parent()
	
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("hotbar_1"):
		selectItem(0)
	
	if event.is_action_pressed("hotbar_2"):
		selectItem(1)
		
func selectItem(inventoryIndex):
	Player.selectedSlot = Player.Inventory[inventoryIndex]