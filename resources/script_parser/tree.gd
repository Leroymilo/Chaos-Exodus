extends ScriptBase
class_name ScriptTree
# contains a list of children to delegate text parsing

var children: Array[ScriptBase] = []

signal end_reached()

func parse(raw_text: String, i: int) -> int:
	while i < raw_text.length():
		
		if raw_text[i] == '{':
			# child is a tag
			i = add_tag(raw_text, i)
		
		elif raw_text[i] in '}|':
			# end of parent custom tag or separator in parent custom tag
			i += 1
			break
		
		else:
			# child is raw text
			i = add_child(ScriptLeaf.new(), raw_text, i)
	return i

func add_tag(raw_text: String, i: int) -> int:
	var end := raw_text.substr(i)
	var child: ScriptBase
	if end.begins_with("{branch|"):
		child = ScriptBranch.new()
	elif end.begins_with("{if_event:"):
		child = ScriptIfEvent.new()
	else:
		child = ScriptInvalid.new()
	
	return add_child(child, raw_text, i)

func add_child(child: ScriptBase, raw_text, i) -> int:
	i = child.parse(raw_text, i)
	total_length += child.total_length
	children.append(child)
	return i

func get_text(length: int) -> RichText:
	if length == -1: length = total_length
	var parts: PackedStringArray = []
	var result := RichText.new()
	for child in children:
		if result.length >= length: break
		var sub_result = child.get_text(length - result.length)
		result.length += sub_result.length
		parts.append(sub_result.text)
	result.text = "".join(parts)
	if result.length < length:
		end_reached.emit()
	return result
