extends Resource
class_name SaveState

@export_storage var position: Vector2i
@export_storage var tools: Dictionary[String, int]
@export_storage var chaos_pos: int
@export_storage var chaos_step: int

func load_from_scenario(scenario: Scenario) -> void:
	position = scenario.start_pos
	tools = scenario.start_tools
	chaos_pos = scenario.start_chaos_pos
	chaos_step = 0

func save() -> void:
	position = Globals.player.tile_pos
	tools = Globals.player.tools
	chaos_pos = Globals.chaos.tile_pos
	chaos_step = Globals.chaos.cur_step
