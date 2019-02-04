extends TileMap

var Tile = preload("res://scenes/Tile.tscn")

var tile_map = []
export var tile_array = []
var click_pos
var tile_index
var tile_id

const map_width = 100
const map_height = 15

func _create_tile_objects():
	var air_tile = Tile.instance()
	air_tile.__init("air", INF, -1)
	
	var dirt_tile = Tile.instance()
	dirt_tile.__init("dirt", 10, 0)
	
	tile_array.append(air_tile)
	tile_array.append(dirt_tile)

func _ready():
	_create_tile_objects()
	init_map()
	reset_map()
	
func _input(event):
	if event.is_action_pressed("reset"):
		reset_map()

func set_tile(pos, tile):
	set_cellv(pos, tile._id)
	tile_map[pos.x][pos.y] = {
		"health": tile.health,
		"_name": tile._name
	}

func init_map():
	for x in range(0, map_width):
		tile_map.append([])
		tile_map[x] = []
		for y in range (0, map_height):
			tile_map[x].append([])
			tile_map[x][y] = {}
	
func reset_map():
	for x in range(0, map_width):
		for y in range (0, map_height):
			set_tile(Vector2(x, y), tile_array[1])
			
	#print(tile_map)

func remove_tile(pos):
	set_tile(pos, tile_array[0])
	
func hit_tile(pos, damage):
	if get_cellv(pos) != -1:
		var tile = tile_map[pos.x][pos.y]
		tile.health -= damage
		
		if tile.health <= 0:
			remove_tile(pos)
