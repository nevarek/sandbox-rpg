extends GridContainer

var InventorySlotScene = preload('res://scenes/InventorySlot.tscn')
onready var Player = get_node('/root/main/Player')
onready var InventoryPanel = get_parent()

var slots = []
const MAX_STACK = 1000

func _ready():
	for slotNum in range(0, 60):
		var newslot = InventorySlotScene.instance()
		add_child(newslot)
		
		slots.append(newslot)
	
	# InventoryPanel.get_canvas_item().visibility

func toggle_view():
	InventoryPanel.visible = !InventoryPanel.visible

func set_view(visibility):
	InventoryPanel.get_canvas_item().visibility = visibility