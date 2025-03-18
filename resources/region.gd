extends Resource
class_name Region

@export var id: String
@export var tiles: Array[TileType] = []
@export var events: Dictionary[Vector2i, Event] = {}
