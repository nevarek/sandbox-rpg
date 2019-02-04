extends Node

onready var Player = get_node('/root/main/Player')

export var items = [
	{
		itemname = "trash",
		itemid = 0
	}
]

func _ready():
	pass
	
func drop_item(item_info):
	print("<drop> %s:ID%d" % [item_info.itemname, item_info.itemid])
