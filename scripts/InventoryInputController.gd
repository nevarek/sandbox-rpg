extends Node

onready var Player = get_node('/root/main/Player')
onready var HotbarPanel = get_node('/root/main/CanvasLayer/UI/HotbarPanel')

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("hotbar_1"):
		select_slot(0)
	
	if event.is_action_pressed("hotbar_2"):
		select_slot(1)
		
	if event.is_action_pressed("hotbar_3"):
		select_slot(2)
		
	if event.is_action_pressed("hotbar_4"):
		select_slot(3)
		
	if event.is_action_pressed("hotbar_5"):
		select_slot(4)
		
	if event.is_action_pressed("hotbar_6"):
		select_slot(5)
		
	if event.is_action_pressed("hotbar_7"):
		select_slot(6)
		
	if event.is_action_pressed("hotbar_8"):
		select_slot(7)
		
	if event.is_action_pressed("hotbar_9"):
		select_slot(8)
	
	if event.is_action_pressed("hotbar_0"):
		select_slot(9)
		
	if event.is_action_pressed("hotbar_-"):
		select_slot(10)
		
	if event.is_action_pressed("hotbar_eq"):
		select_slot(11)
		
func select_slot(slotIndex):
	Player.Inventory.select_slot(slotIndex)
	HotbarPanel.select_slot(slotIndex)