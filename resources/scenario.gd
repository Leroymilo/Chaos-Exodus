extends Resource
class_name Scenario

@export var name: String
@export var start_region: Region
@export var start_pos := Vector2i(2, 2)
@export var start_event: EventData
@export var start_tools: Dictionary[Globals.Tool, int] = {
	Globals.Tool.Time_: 0,
	Globals.Tool.Energy: 5
}
@export var start_chaos_pos := 0
