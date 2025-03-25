extends Resource
class_name ScriptBase

static var branch_nodes: Array[ScriptBranch] = []

class RichText:
	var text := ""
	var length := 0
	
var total_length: int	# length in written characters (does not count bbcode tags)

@warning_ignore("unused_parameter")
func parse(raw_text: String, i: int) -> int:
	# returns the index where the parent should continue parsing
	return i
