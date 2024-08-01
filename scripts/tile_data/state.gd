class_name TileState
extends Resource

@export_group("DO NOT EDIT HERE")

@export var id: int
@export var obstruction: int = 0
@export var layer_paths: Array[String] = []
@export var traversal_options: Array[TraversalOption] = []

func add_layer(path: String):
	layer_paths.append(path)

func set_layer(index: int, new_path: String):
	layer_paths[index] = new_path

func remove_layer(index: int):
	layer_paths.pop_at(index)

func add_trav_opt() -> TraversalOption:
	var trav_opt = TraversalOption.new()
	trav_opt.id = traversal_options.size()
	trav_opt.next_state = id
	traversal_options.append(trav_opt)
	return trav_opt

func get_trav_opt(index: int):
	return traversal_options[index]

func remove_trav_opt(index: int):
	traversal_options.remove_at(index)
	for i in range(index, traversal_options.size()):
		traversal_options[i].id = i
