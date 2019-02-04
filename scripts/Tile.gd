extends Node

export var _name = "air"
export var health = 10
export var _id = -1
export var collision_bitmap = []

func __init(tile_name, tile_health, tile_id):
	_name = tile_name
	health = tile_health
	_id = tile_id