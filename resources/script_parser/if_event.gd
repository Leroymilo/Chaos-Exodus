extends ScriptBase
class_name ScriptIfEvent
# handles conditional text on whether or not
# an event was met by the player

# format: {if_event:<event_id>|text if event_id was met|text if it wasn't}

var condition: EventCondition
var children: Dictionary[bool, ScriptTree] = {}

func parse(raw_text: String, i: int) -> int:
	i += "{if_event:".length()
	var j = raw_text.find('|', i)
	condition = EventCondition.new(raw_text.substr(i, j-i))
	i = j+1
	children[true] = ScriptTree.new()
	i = children[true].parse(raw_text, i)
	children[false] = ScriptTree.new()
	i = children[false].parse(raw_text, i)
	return i

func get_text(length: int) -> RichText:
	return children[condition.value].get_text(length)
