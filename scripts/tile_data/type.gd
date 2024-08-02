class_name TileType
extends Resource

static var default_sprite_path: String = "res://sprites/tiles/no_sheet.png"

@export_group("DO NOT EDIT HERE")

@export var id: int
@export var name: String

@export var state: int = 0
@export var visibility: int	# Visibility

@export var states: Array[TileState] = []

@export var base_layer_paths: Array[String]

func init(p_id: int, p_name: String) -> TileType:
	id = p_id
	name = p_name
	return self

func add_state() -> TileState:
	var new_state = TileState.new()
	new_state.id = states.size()
	states.append(new_state)
	return new_state

func remove_state(index: int):
	states.remove_at(index)
	for i in range(index, states.size()):
		states[i].id = i

func add_layer(path: String):
	base_layer_paths.append(path)

func swap_layers(i1: int, i2: int):
	var temp = base_layer_paths[i1]
	base_layer_paths[i1] = base_layer_paths[i2]
	base_layer_paths[i2] = temp

func remove_layer(index: int):
	base_layer_paths.remove_at(index)
