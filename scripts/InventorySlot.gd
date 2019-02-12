extends Control

const NULL_ITEM = {
	"_name": null,
	"_id": -1,
	"texture": null,
	"count": -1
}

export (Dictionary) var item = NULL_ITEM

func _ready():
	item = NULL_ITEM

func set_item(item_info, count = 0):
	item = {
		"_name": item_info._name,
		"_id": item_info._id,
		"texture": item_info.texture,
		"count": item_info.count || count
	}
	
	if (item.count <= 0):
		item = NULL_ITEM
		
func get_item():
	return item
	
func is_empty():
	return item == NULL_ITEM