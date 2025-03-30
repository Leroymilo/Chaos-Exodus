extends ScriptTrigger
class_name ScriptTool
# handles anything tool related

# format: {tool:<mode>:<tool name>:<count>}

enum Mode {enable, disable, add, set_}

var mode: Mode
var tool: String
var count := 0

var err_msg: String = ""

func parse(raw_text: String, i: int) -> int:
	i += "{tool:".length()
	var j = raw_text.find(':', i)
	var mode_name := raw_text.substr(i, j-i)
	if not Mode.has(mode_name):
		err_msg = "Invalid mode name: " + mode_name
		return raw_text.find('}', i) + 1
	mode = Mode[mode_name]
	
	i = j+1
	j = raw_text.find(':', i)
	tool = raw_text.substr(i, j-i)
	if Globals.save_data.scenario.get_tool(tool) == null:
		err_msg = "Invalid tool name: " + tool
		return raw_text.find('}', i) + 1
	
	i = j+1
	j = raw_text.find('}', i)
	count = raw_text.substr(i, j-i).to_int()
	return j + 1

func get_text(length: int) -> RichText:
	var result = RichText.new()
	if length < 1: return result
	if err_msg != "":
		result.text = err_msg.substr(0, length)
		result.length = result.text.length()
	elif not triggered:
		triggered = true
		match mode:
			Mode.enable:
				Globals.player.set_tool(tool, count)
			Mode.disable:
				Globals.player.remove_tool(tool)
			Mode.add:
				Globals.player.add_tool(tool, count)
			Mode.set_:
				Globals.player.set_tool(tool, count)
	
	return result
