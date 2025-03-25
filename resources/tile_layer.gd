extends Resource
class_name TileLayer

@export var row: int = 0
@export var z_index: int = 0
@export var border_conditions: Dictionary[Vector2i,String] = {}
# neighbor position -> required tag
@export var story_condition: Condition
