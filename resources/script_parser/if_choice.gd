extends ScriptBase
class_name ScriptIfChoice
# handles conditional text on whether or not
# a choice was taken by the player

# format: {if_choice:<event_id>:<branch_id>|text if choice branch_id was taken|text if it wasn't}

var condition: ChoiceCondition
var children: Dictionary[bool, ScriptTree] = {}

func parse(raw_text: String, i: int) -> int:
	i += "{if_choice:".length()
	var j = raw_text.find(':', i)
	var event_id := raw_text.substr(i, j-i)
	i = j+1
	j = raw_text.find('|', i)
	var branch_id := raw_text.substr(i, j-i)
	i = j+1
	
	condition = ChoiceCondition.new(event_id, branch_id)
	children[true] = ScriptTree.new()
	i = children[true].parse(raw_text, i)
	children[false] = ScriptTree.new()
	i = children[false].parse(raw_text, i)
	return i

func get_text(length: int) -> RichText:
	return children[condition.value].get_text(length)
