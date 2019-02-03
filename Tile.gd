extends Sprite

export var _name = "air"
export var health = 10
export var _id = -1

func __init(tile_name, tile_health, tile_id, tile_texture):
	_name = tile_name
	health = tile_health
	_id = tile_id
	texture = tile_texture