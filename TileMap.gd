extends TileMap

var Tile = preload("res://Tile.tscn")

var DirtTexture = preload("res://assets/Dirt.png")

var tile_map = []
var tile_array = []
var click_pos
var tile_index
var tile_id

func _create_tile_objects():
	var air_tile = Tile.instance()
	air_tile.__init("air", -1, -1, null)
	
	var dirt_tile = Tile.instance()
	dirt_tile.__init("dirt", 10, 0, DirtTexture)
	
	tile_array.append(air_tile)
	tile_array.append(dirt_tile)

func _ready():
	_create_tile_objects()
	_load_tiles()
	init_map()
	
func _input(event):
	
	if event.is_action_pressed("primaryFire"):
		click_pos = get_global_mouse_position()
		tile_index = world_to_map(click_pos)
		
		hit_tile(tile_index, 5)
		
	if event.is_action_pressed("ui_select"):
		reset_map()

func set_tile(pos, tile):
	set_cellv(pos, tile._id)
	tile_map[pos.x][pos.y] = {
		"health": tile.health,
		"_name": tile._name
	}

func init_map():
	for x in range(0, 3):
		tile_map.append([])
		tile_map[x] = []
		for y in range (0, 3):
			tile_map[x].append([])
			tile_map[x][y] = {}
			set_tile(Vector2(x, y), tile_array[1])
	
func reset_map():
	for x in range(0, 3):
		for y in range (0, 3):
			set_tile(Vector2(x, y), tile_array[1])
			
	print(tile_map)
	
func _load_tiles():
	var index = 0
	var newtile = tile_array[index + 1]
	
	tile_set.create_tile(index)
	tile_set.tile_set_texture(index, newtile.texture)

func remove_tile(pos):
	set_tile(pos, tile_array[0])
	
func hit_tile(pos, damage):
	if get_cellv(pos) != -1:
		var tile = tile_map[pos.x][pos.y]
		tile.health -= damage
		
		if tile.health <= 0:
			remove_tile(pos)
