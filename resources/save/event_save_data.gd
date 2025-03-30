extends Resource
class_name EventSaveData

@export var number: int

@export var start_state: SaveState
# holds the state of the game when this event started

@export var finished := false
@export var finished_text: String = ""
# holds the sum of text of the scripts that the player
# already went through (their effects were saved)
@export var script_queue: Array[String] = []
# queue of scripts paths that are left to write
@export var branches: PackedStringArray = []
# list of branch_ids that were taken by the player
@export var branch_paths: Dictionary[String, String] = {}
# copied over from the EventData
@export var triggered_triggers: PackedInt32Array = []
# keeps tracks of which ScriptTrigger was triggered

func get_turn() -> int:
	return start_state.tools[Tool.time.name]

func take_branch(branch_id: String) -> String:
	# returns potential path associated with branch_id
	branches.append(branch_id)
	Globals.save_data.save()
	return branch_paths.get(branch_id, "")
