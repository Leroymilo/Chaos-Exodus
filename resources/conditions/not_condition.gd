extends Condition
class_name NotCondition

@export var input: Condition:
	set(new_val):
		if new_val == null: return
		input = new_val
		value = not input.value
		input.value_changed.connect(update_value)

func update_value():
	if input.value == value:
		value = not input.value
		value_changed.emit()
