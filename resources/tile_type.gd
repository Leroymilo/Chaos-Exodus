extends Resource
class_name TileType

const LAYER_FRAME_SIZE := Vector2i(80, 80)

@export var id: String
@export var tag: String

@export var sprite_sheet: CompressedTexture2D:
	set(value):
		sprite_sheet = value
		frames = Vector2i(sprite_sheet.get_size()) / LAYER_FRAME_SIZE
var frames: Vector2i
@export var layers: Array[TileLayer] = []

@export var actions: Array[Action] = []:
	set(value):
		actions = value
		queue.assign(range(actions.size()))
var queue: Array[int] = []
var cur_act: Dictionary[bool, int] = {false: -1, true: -1}

@export var obstruct: int
@export var visibility: int

func get_valid_ids(move: bool) -> Array[int]:
	var valid_ids: Array[int]
	if Globals.sort_by_last_used: valid_ids.assign(queue)
	else: valid_ids.assign(range(actions.size()))
	valid_ids = valid_ids.filter(func(i):return actions[i].is_valid(move))
	return valid_ids

func get_action(move: bool) -> Action:
	var valid_ids := get_valid_ids(move)
	
	if valid_ids.size() == 0:
		cur_act[move] = -1
		Globals.player.set_action_indicator(0)
		if move:
			Globals.show_action.emit(Action.no_move)
		else:
			Globals.show_action.emit(Action.no_action)
		return null
	
	if cur_act[move] == -1:
		cur_act[move] = valid_ids[0]
	Globals.player.set_action_indicator(
		valid_ids.size(), valid_ids.find(cur_act[move])
	)
	Globals.show_action.emit(actions[cur_act[move]])
	return actions[cur_act[move]]

func change_action(forward: bool, move: bool) -> void:
	var diff : int
	if forward: diff = 1
	else: diff = -1
	var valid_ids := get_valid_ids(move)
	
	if valid_ids.size() == 0:
		cur_act[move] = -1
		Globals.player.set_action_indicator(0)
		Globals.show_action.emit(Action.empty_action)
		return
	
	var index = valid_ids.find(cur_act[move])
	index = (index + diff) % valid_ids.size()
	cur_act[move] = valid_ids[index]
	Globals.player.set_action_indicator(valid_ids.size(), index)
	Globals.show_action.emit(actions[cur_act[move]])

func use_action(move: bool) -> bool:
	var index = cur_act[move]
	
	if index == -1: return false
	
	if actions[index].use(move):
		queue.erase(index)
		queue.push_front(index)
		return true
	return false
