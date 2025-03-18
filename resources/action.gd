extends Resource
class_name Action

@export var tools: Dictionary[Globals.Tool, int] = {}
@export var choices: Dictionary[String, PackedStringArray] = {}
@export var is_move: bool = true

func is_valid(move: bool) -> bool:
	# does not need enough tools to be valid, only unlock them.
	if move != is_move:
		return false
	
	if not Globals.player.tools.has_all(tools.keys()):
		return false
	
	for event_key in choices:
		if event_key not in Globals.save_data.event_choices:
			return false
		for choice in choices[event_key]:
			if choice not in Globals.save_data.event_choices[event_key]:
				return false
	
	return true

func use(move: bool) -> bool:
	if not is_valid(move): return false
	
	var has_enough = true
	for tool in tools.keys():
		var count = tools[tool]
		if count > 0: continue
		if Globals.player.tools[tool] < -count:
			has_enough = false
			Globals.to_blink.append(tool)
	if not has_enough: return false
	
	for tool in tools.keys():
		var count = tools[tool]
		Globals.player.tools[tool] += count
	return true
