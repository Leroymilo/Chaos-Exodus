extends Condition
class_name LogicCondition

enum GateType {UNDEF, AND, OR, XOR}

@export var inputs: Array[Condition]:
	set(new_val):
		if new_val == null: return
		inputs = new_val
		value = compute_value()
		for input in inputs:
			input.value_changed.connect(update_value)

@export var gate_type: GateType = GateType.UNDEF:
	set(new_val):
		gate_type = new_val
		value = compute_value()

func compute_value() -> bool:
	if gate_type == GateType.UNDEF: return false
	if inputs == null: return false
	
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
