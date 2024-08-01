extends Resource

@export_group("DO NOT EDIT HERE")

@export var id: int
@export var x_start: int = 0
@export var height: int = 5
@export var data: Array[TileType] = []
# '2D' array of TileType flattened

func get_tile(x: int, y: int):
	return data[x * height + y]
