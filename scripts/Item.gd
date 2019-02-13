extends RigidBody2D

var _item_info = {}
var _id = -1
var _name = null
var count = 0
var texture_ref = null

func spawn(parent_instance, spawn_position, item_info):
	position = spawn_position
	_set_properties(item_info)
	parent_instance.add_child(self)

func _set_properties(item_info):
	_id = item_info._id
	_name = item_info._name
	count = 1
	texture_ref = item_info.texture_ref
	
	$Sprite.texture = texture_ref
	
	_item_info = item_info

func pickup():
	queue_free()
	return self
	