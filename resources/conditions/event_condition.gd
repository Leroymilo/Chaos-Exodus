extends Condition
class_name EventCondition

@export var event_id: String

func _init(p_event_id: String = "") -> void:
	Globals.event_triggered.connect(update_value)
	if p_event_id == "": return
	event_id = p_event_id
	value = Globals.save_data.events_data.has(event_id)

func update_value(event_nb: int):
	if Globals.save_data.events_order[event_nb] == event_id and not value:
		value = true
		value_changed.emit()
