extends ScriptBase
class_name ScriptTrigger
# base class for any Script tag that should only be triggered once
# examples: ScriptTool, ScriptRegion

static var triggers: Array[ScriptTrigger] = []
var index: int
var triggered := false:
	set(value):
		if value: trigger.emit()
		triggered = value

signal trigger()

func _init() -> void:
	index = triggers.size()
	triggers.append(self)
	
