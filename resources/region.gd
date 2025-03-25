extends Resource
class_name Region

@export var id: String
@export var tiles: Array[TileType] = []
@export var events: Dictionary[Vector2i, EventData] = {}

@export var chaos_delay := 0
# 0 means no chaos on this region
