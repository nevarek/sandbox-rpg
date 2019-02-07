"""
HotbarPanelController

Controls the logic for the hotbar like moving the selector
"""

extends Panel

func _ready():
	pass
	
func select_slot(index):
	$Grid/SelectionSquare.position = $Grid.get_child(index).get_rect().position
