extends Condition
class_name LogicCondition

enum GateType {AND, OR, XOR}

@export var inputs: Array[Condition]
@export var gate_type: GateType

func _init(p_inputs: Array[Condition], p_type: GateType) -> void:
	inputs = p_inputs
	gate_type = p_type
	value = compute_value()
	for input in inputs:
		input.value_changed.connect(update_value)

func compute_value() -> bool:
	var count_true = 0
	for input in inputs:
		if input.value:
			count_true += 1
	
	match gate_type:
		GateType.AND:
			return (count_true == inputs.size())
		GateType.OR:
			return (count_true > 0)
		GateType.XOR:
			return (count_true%2 == 1)
	return false	# to avoid not returning a value

func update_value():
	var new_value = compute_value()
	if new_value != value:
		value = new_value
		value_changed.emit()
