extends Condition
class_name ChoiceCondition

@export var event_id: String
@export var choice_id: String

func _init(p_event_id: String, p_choice_id: String) -> void:
	event_id = p_event_id
	choice_id = p_choice_id
	value = Globals.save_data.has_event_choice(event_id, choice_id)
	Globals.choice_taken.connect(update_value)

func update_value(p_event_id: String, p_choice_id: String):
	if p_event_id == event_id and p_choice_id == choice_id and not value:
		value = true
		value_changed.emit()
