extends Resource
class_name SaveData

@export_storage var save_name: String

@export_storage var scenario: Scenario
@export_storage var region: Region

@export_storage var state: SaveState

@export_storage var events_data: Dictionary[String, EventSaveData]
# event_id -> event_data
@export_storage var events_order: PackedStringArray
# stores ids of events met in order

func load_from_scenario(p_scenario: Scenario) -> void:
	save_name = "Demo Save"
	scenario = p_scenario
	region = scenario.start_region
	state = SaveState.new()
	state.load_from_scenario(scenario)
	
	# adding initial event
	var event_save_data := EventSaveData.new()
	event_save_data.branch_paths = scenario.start_event.branch_paths
	event_save_data.number = 0
	event_save_data.start_state = state.duplicate(true)
	event_save_data.script_queue.append(scenario.start_event.script_path)
	events_data[scenario.start_event.id] = event_save_data
	events_order.append(scenario.start_event.id)
	
	# saving to file
	DirAccess.make_dir_recursive_absolute("res://saves/")
	ResourceSaver.save(Globals.save_data, "res://saves/demo_save.tres", )

func add_event(event_data: EventData) -> void:
	state.save()
	var event_save_data := EventSaveData.new()
	event_save_data.branch_paths = event_data.branch_paths
	event_save_data.number = events_order.size()
	event_save_data.start_state = state.duplicate(true)
	event_save_data.script_queue.append(event_data.script_path)
	events_data[event_data.id] = event_save_data
	events_order.append(event_data.id)
	save()
	Globals.event_triggered.emit(event_save_data.number)

func has_event_choice(event_id: String, branch_id: String) -> bool:
	if events_data.has(event_id):
		return events_data[event_id].branches.has(branch_id)
	return false

func save() -> void:
	state.save()
	ResourceSaver.save(Globals.save_data, "res://saves/demo_save.tres")
