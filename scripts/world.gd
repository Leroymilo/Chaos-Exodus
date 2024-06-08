extends Node2D

const MAP_WIDTH = 5
var map_data = [
	"type:forest",
	"biome:jungle",
	"biome:jungle",
	"biome:jungle",
	["type:peak", "type:mount", "biome:jungle", "type:mount", "type:peak"]
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(map_data.size()):
		parse_map_row(map_data[x], x)

func parse_map_row(row_data, x: int):
	if row_data is String:
		var new_row: Array[String] = []
		new_row.resize(MAP_WIDTH)
		new_row.fill(row_data)
		row_data = new_row
	
	assert(row_data is Array, "Invalid map row data.")
	
	for y in range(MAP_WIDTH):
		assert(row_data[y] is String, "Invalid map row data.")
		var tile_data = row_data[y].split(':')
		var tile = Tile.instantiate(
			tile_data[1], Vector2i(x, y),
			tile_data[0] == "biome"
		)
		$Map.add_child(tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
