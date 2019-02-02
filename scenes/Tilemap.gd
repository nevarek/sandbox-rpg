extends TileMap

var TilePool = []

const width = 10
const height = 10

var tile_index
var tile_id

# TODO need to deep copy these tiles (or instance them as nodes?)
var tileid_map = { 
	"invalid": {
		"name": "air",
		"hardness": -1,
		"tile_id": -1
	},
	0: {
		"name": "dirt",
		"hardness": 10,
		"tile_id": 0
	},
	1: {
		"name": "stone",
		"hardness": 20,
		"tile_id": 1
	}
}

func _ready():
	_init_tilemap()
	generate_tilemap()
	
func _process(delta):
	pass
	
func _init_tilemap():
	for x in range(0, width):
		TilePool.append([])
		TilePool[x] = []
		for y in range(0, height):
			var newtile = tileid_map["invalid"]
			TilePool[x].append([])
			TilePool[x][y] = newtile

func hit_tile_at(target, damage):
	tile_index = world_to_map(target)
	tile_id = get_cellv(tile_index)
	
	var tile = _get_cell_at(tile_index)
	
	tile.hardness -= damage
	
	if tile.hardness <= 0:
		_remove_tile_at(tile_index)
	
func _set_cell_at(cell_position, value):
	TilePool[cell_position.x][cell_position.y] = value
	set_cellv(cell_position, value.tile_id)

func _get_cell_at(cell_position):
	return TilePool[cell_position.x][cell_position.y]

func _remove_tile_at(tile_index):
	set_cellv(tile_index, INVALID_CELL)
	
	drop_tileitem()
	
func generate_tilemap():
	for x in range(0, width):
		for y in range(0, height):
			var newtile = tileid_map[0]
			_set_cell_at(Vector2(x, y), newtile)

func drop_tileitem():
	if tile_id != -1:
		print('<drop> ' + str(tileid_map[tile_id].name))
		print(TilePool)