extends Condition
class_name EventCondition

@export var event_id: String

func _init(p_event_id: String) -> void:
	event_id = p_event_id
	value = Globals.save_data.events_data.has(event_id)
	Globals.event_triggered.connect(update_value)

func update_value(p_event_id: String):
	if p_event_id == event_id and not value:
		value = true
		value_changed.emit()
