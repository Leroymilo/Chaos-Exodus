extends Node2D
class_name Event

@export var data: EventData:
	set(value):
		data = value
		data.condition.value_changed.connect(on_condition_changed)
		on_condition_changed()
		triggered = Globals.save_data.events_data.has(data.id)
		if data.hidden: hide()

var triggerable: bool
var triggered: bool = false

func on_condition_changed():
	if triggered: return
	if data.condition.value and not data.hidden:
		show()
	else:
		hide()
	triggerable = data.condition.value

func trigger():
	hide()
	triggerable = false
	triggered = true
	Globals.save_data.add_event(data)
