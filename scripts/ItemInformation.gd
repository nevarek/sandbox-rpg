"""
ItemInformation

Contains meta information about the items in the game.

This is not the player's inventory, but a singleton reference for scenes to use
"""
extends Node

const ITEM_TEXTURE_PATH_PREFIX = "res://assets/items/"

var NULL_ITEM = {}

var item_list
var item_textures
var ui_item_textures

const MAX_ITEM_STACK = 5

var Items = {}

func _ready():
	item_list = []
	item_textures = []
	ui_item_textures = []
	
	_load_item_list()
	_load_item_textures()
	
	NULL_ITEM = item_list[0]

func _load_item_textures():
	var item_texture_path
	
	for item in item_list:
		item_texture_path = ITEM_TEXTURE_PATH_PREFIX + str(item.texture_ref)
		var texture = load(item_texture_path)
		item_textures.append(texture)
		item.texture_ref = texture
		
		item_texture_path = ITEM_TEXTURE_PATH_PREFIX + str(item.ui_texture_ref)
		texture = load(item_texture_path)
		ui_item_textures.append(texture)
		item.ui_texture_ref = texture
		
		item.max_stack = int(item.max_stack)
		item._id = int(item._id)
		

func _load_json_information(path):
	var result
	
	var file = File.new()
	
	if !file.file_exists(path):
		push_error("[Inventory] Error occurred opening file \"%s\"" % path)
		
	result = file.open(path, File.READ)
	
	var content = file.get_as_text()
	file.close()
	
	result = JSON.parse(content)
	if result.error != OK:
		push_error("[Inventory] Error occurred parsing JSON file")
	
	return result.result
	
func _load_item_list():
	Items = _load_json_information("res://data/items.json")
	for item_index in Items:
		item_list.append(Items[item_index])
