extends Node2D

const Tile = preload("res://scenes/tile.tscn")

const MAP_WIDTH = 5
var map_data = [
	"type:forest",
	"biome:jungle", null, null,	# null get filled with previous valid row
	["type:peak", "type:mount", "biome:jungle", "type:mount", "type:peak"]
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(map_data.size()):
		parse_map_row(x)

func is_row_data_valid(row_data):
	if row_data is int or row_data is String:
		return true
	if row_data is Array:
		for val in row_data:
			if val is String:
				continue
			return false
		return true

func parse_map_row(x: int):
	
	var row_data = map_data[x]
	
	if not is_row_data_valid(row_data):
		var ref = x - 1
		while ref >= 0 and not is_row_data_valid(map_data[ref]):
			ref -= 1
		assert(ref >= 0, "No valid row under x = %d" % x)
		
		if map_data[ref] is int:
			map_data[x] = map_data[ref]
		else:
			map_data[x] = ref
			
		row_data = map_data[x]
	
	assert(is_row_data_valid(row_data), "Invalid map row data.")
	# just to be sure, it shouldn't throw any error
	
	if row_data is int:
		row_data = map_data[row_data]
	
	if row_data is String:
		var new_row: Array[String] = []
		new_row.resize(MAP_WIDTH)
		new_row.fill(row_data)
		row_data = new_row
	
	for y in range(MAP_WIDTH):
		add_tile(row_data[y], Vector2i(x, y))

func add_tile(type: String, pos: Vector2i):
	var tile = Tile.instantiate()
	var type_data = type.split(':')
	tile.set_type(type_data[1], type_data[0] == "biome")
	tile.set_pos(pos)
	$Map.add_child(tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
