class_name TraversalOption
extends Resource

@export_group("DO NOT EDIT HERE")

#@export var tools: Array[String] = []
#@export var tool_counts: Array[int] = []

@export var id: int

@export var delay: int = 1		# Time to traverse the tile with this option
@export var vis_modif: int = 0	# Offset the tile's visibility
@export var next_state: int = 0	# State of the tile after using this option

@export var tools: OrderedDict = OrderedDict.new()

func add_tool(tool_name: String) -> int:
	assert(not tools.has(tool_name), "Tool already exists!")
	tools.append(tool_name, 1)
	return tools.size() - 1

func get_tool_name(index: int) -> String:
	return tools.list[index]

func remove_tool(index: int):
	tools.erase(index)
