extends Node2D
class_name Event

@export var data: EventData:
	set(value):
		data = value
		data.condition.value_changed.connect(on_condition_changed)
		on_condition_changed()
		triggered = Globals.save_data.events_data.has(data.id)
		print("event ", data.id, " already triggered? ", triggered)

var triggerable: bool
var triggered: bool = false

func on_condition_changed():
	if triggered: return
	if data.condition.value:
		show()
	else:
		hide()
	triggerable = data.condition.value

func trigger():
	hide()
	triggerable = false
	triggered = true
	Globals.save_data.add_event(data)
