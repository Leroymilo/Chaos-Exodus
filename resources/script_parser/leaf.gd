extends ScriptBase
class_name ScriptLeaf
# contains only plain text (should not contain bbcode tags)

var text: String

func parse(raw_text: String, i: int) -> int:
	var j = i
	while j < raw_text.length():
		if raw_text[j] in "{}|":
			# start, end or separator of a custom tag
			break
		j += 1
	total_length = j - i
	text = raw_text.substr(i, total_length)
	return j

func get_text(length: int) -> RichText:
	if length == -1: length = total_length
	var result := RichText.new()
	result.text = text.substr(0, length)
	result.length = result.text.length()
	return result
