extends ScriptLeaf
class_name ScriptInvalid

func parse(raw_text: String, i: int) -> int:
	var j = i
	while j < raw_text.length():
		if raw_text[j] == '}':
			# end of the invalid tag
			break
		j += 1
	total_length = j - i
	text = raw_text.substr(i, total_length)
	return j
