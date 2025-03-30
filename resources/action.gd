extends Resource
class_name Action

static var empty_action: Action
static var no_action: Action
static var no_move: Action

@export var tools: Dictionary[String, int] = {}
@export var condition: Condition = TrueCondition.new()
@export var is_move: bool = true
@export var description: String = ""

static func _static_init() -> void:
	empty_action = new()
	no_move = new()
	no_move.description = "No move to this tile."
	no_action = new()
	no_action.is_move = false
	no_action.description = "No action on this tile."

func is_valid(move: bool) -> bool:
	# does not need enough tools to be valid, only unlock them.
	if move != is_move:
		return false
	
	if not Globals.player.tools.has_all(tools.keys()):
		return false
	
	return condition.value

func use(move: bool) -> bool:
	if not is_valid(move): return false
	
	var has_enough = true
	for tool in tools.keys():
		var count = tools[tool]
		if count > 0: continue
		if Globals.player.tools[tool] < -count:
			has_enough = false
			Globals.blink_tool.emit(tool)
	if not has_enough: return false
	
	for tool in tools.keys():
		var count = tools[tool]
		Globals.player.add_tool(tool, count)
	return true
