extends Control

const ToolDisplay := preload("res://scenes/tool_display.tscn")

@onready var map: SubViewport = %Map
@onready var tools: HFlowContainer = %Tools

var tool_map: Dictionary[Globals.Tool, Control] = {}

func _ready() -> void:
	Globals.player = map.get_node("%Player")
	load_data()
	map._on_player_target_moved()

func load_data() -> void:
	Globals.save_data = load("res://saves/default.tres")
	map.region = load("res://assets/scenarios/{0}/map/{1}.tres".format(
		[Globals.save_data.scenario_id, Globals.save_data.region_id]
	))
	Globals.player.tile_pos = Globals.save_data.position
	Globals.player.tools = Globals.save_data.tools
	
	
	for tool in Globals.player.tools:
		var new_tool = ToolDisplay.instantiate()
		new_tool.tool = tool
		tools.add_child(new_tool)
		tool_map[tool] = new_tool

func save_data() -> void:
	Globals.save_data.position = Globals.player.tile_pos
	Globals.save_data.tools = Globals.player.tools
	ResourceSaver.save(Globals.save_data, "res://saves/test_save.tres")

func update_tools() -> void:
	for tool in tools.get_children():
		tool.update_count()

func missing_tools() -> void:
	for tool in Globals.to_blink:
		tool_map[tool].blink(true)
	Globals.to_blink.clear()

func show_action(action: Action) -> void:
	for tool in tool_map.keys():
		if action != null and action.tools.has(tool):
			tool_map[tool].show_diff(action.tools[tool])
		else:
			tool_map[tool].show_diff(0)

func _on_grid_toggled(toggled_on: bool) -> void:
	Globals.show_grid = toggled_on
