extends Resource
class_name EventSaveData

@export var event_data: EventData
@export var number: int
@export var tile_pos: Vector2i
@export var turn: int

@export var finished := false
@export var finished_text: String = ""
# holds the sum of text of the scripts that the player
# already went through (their effects were saved)
@export var script_queue: Array[String] = []
# queue of scripts paths that are left to write
@export var branches: PackedStringArray = []
# list of branch_ids that were taken by the player

func take_branch(branch_id: String) -> String:
	# returns potential path associated with branch_id
	branches.append(branch_id)
	Globals.save_data.save()
	return event_data.branch_paths.get(branch_id, "")
