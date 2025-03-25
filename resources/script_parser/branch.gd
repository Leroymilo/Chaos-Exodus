extends ScriptBase
class_name ScriptBranch
# handles a branch in the script:
# it will wait for the player to choose in a list,
# and then load and parse another script

# format: {branch|<branch_id0>:first choice description|<branch_id1>:second choice description}
# any number of branches is possible (choices will appear in a column)

var branch_ids: PackedStringArray = []
var branch_displays: Dictionary[String, ScriptTree] = {}
# how the branches will be shown in the journal (instead of their ids)
var current := -1		# to avoid spam selecting
var selected := false	# to know when the player selected one of the branches

signal choice_started(branch_node: ScriptBranch)
signal choice_made(branch_id: String)

func parse(raw_text: String, i: int) -> int:
	branch_nodes.append(self)
	total_length = 1
	i += "{branch|".length()
	
	while raw_text[i-1] != '}' and i < raw_text.length():
		var j = raw_text.find(':', i)
		var branch_id = raw_text.substr(i, j-i)
		branch_ids.append(branch_id)
		var display = ScriptTree.new()
		i = display.parse(raw_text, j+1)
		branch_displays[branch_id] = display
	
	return i

func set_selection(branches_taken: PackedStringArray) -> void:
	for i in range(branches_taken.size()):
		var branch_id := branches_taken[i]
		if branch_displays.has(branch_id):
			current = branch_ids.find(branch_id)
			selected = true

func handle_event(event: InputEvent) -> bool:
	if event.is_action_pressed("ui_accept") and current >= 0:
		selected = true
		choice_made.emit(branch_ids[current])
	elif event.is_action_pressed("ui_down"):
		current = (current + 1) % branch_ids.size()
		return true
	elif event.is_action_pressed("ui_up"):
		if current < 0: current = branch_ids.size()
		current = (current - 1) % branch_ids.size()
		return true
	return false

func get_text(length: int) -> RichText:
	var result := RichText.new()
	if branch_ids.size() == 0: return result
	
	if branch_ids.size() == 1:
		if selected:
			choice_made.emit(branch_ids[0])
			selected = true
		return result
	
	if selected:
		result.text = "\nChoice made: "
		result.length = result.text.length()
		if length - result.length > 0:
			var sub_result = branch_displays[branch_ids[current]].get_text(length - result.length)
			result.text += sub_result.text + "\n"
			result.length += sub_result.length
	else:
		result.text = "\nMake a choice: [center]"
		for i in range(branch_ids.size()):
			var branch_id := branch_ids[i]
			var display := branch_displays[branch_id].get_text(-1).text
			if i == current:
				var space := " "
				if (Time.get_ticks_msec() / 1000) % 2: space = ""
				# animates carrets moving in and out
				display = "> " + space + display + space + " <"
			result.text += display + '\n'
		result.text += "[/center]"
		result.length = 1	# to show all at once
		choice_started.emit(self)
	
	return result
