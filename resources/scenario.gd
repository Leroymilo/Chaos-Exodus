extends Resource
class_name Scenario

@export var name: String
@export var start_region: Region
@export var start_pos := Vector2i(2, 2)
@export var start_event: EventData
@export var tools: Array[Tool] = [Tool.time]
@export var start_tools: Dictionary[String, int] = {"time": 0}
@export var start_chaos_pos := 0

func get_tool(tool_name: String) -> Tool:
	for tool in tools:
		if tool.name == tool_name: return tool
	return null
