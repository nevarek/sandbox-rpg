extends RigidBody2D

var item_info = {}

func spawn(parent_instance, spawn_position, new_item_info, count = 1):
	position = spawn_position
	item_info = new_item_info
	item_info.count = count
	_set_properties(item_info)
	parent_instance.add_child(self)

func _set_properties(item_info):
	item_info = item_info
	$Sprite.texture = item_info.texture_ref

func pickup():
	queue_free()
	return self.item_info
	