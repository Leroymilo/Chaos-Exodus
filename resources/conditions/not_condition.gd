extends Condition
class_name NotCondition

@export var input: Condition

func _init(p_input: Condition) -> void:
	input = p_input
	value = not input.value
	input.value_changed.connect(update_value)

func update_value():
	if input.value == value:
		value = not input.value
		value_changed.emit()
