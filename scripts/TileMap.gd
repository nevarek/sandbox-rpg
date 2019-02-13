# TODO map tiles to item IDs
extends TileMap

onready var ItemSpawnManager = get_node('/root/main/GlobalControllers/ItemSpawnManager')
onready var InventoryManager = get_node('/root/main/CanvasLayer/UI/Inventory')

var Tile = preload("res://scenes/Tile.tscn")

var tile_map = []
export var tile_array = []
var click_pos
var tile_index
var tile_id

const map_width = 500
const map_height = 100

func _create_tile_objects():
	var air_tile = Tile.instance()
	air_tile.__init("air", INF, -1)
	
	var dirt_tile = Tile.instance()
	dirt_tile.__init("dirt", 10, 0)
	
	var stone_tile = Tile.instance()
	stone_tile.__init("stone", 20, 1)
	
	tile_array.append(air_tile)
	tile_array.append(dirt_tile)
	tile_array.append(stone_tile)

func _ready():
	randomize()
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
	var value
	for x in range(0, map_width):
		for y in range (0, map_height):
			value = randi() % 2 + 1
			set_tile(Vector2(x, y), tile_array[value])
			
	#print(tile_map)

func remove_tile(pos):
	var tile = get_cellv(pos)
	set_tile(pos, tile_array[0])
	
	var item_id = tile

	ItemSpawnManager.drop_item(InventoryManager.get_item_list()[item_id + 1], map_to_world(pos))
	
func hit_tile(pos, damage):
	if get_cellv(pos) != -1:
		var tile = tile_map[pos.x][pos.y]
		tile.health -= damage
		
		if tile.health <= 0:
			remove_tile(pos)
