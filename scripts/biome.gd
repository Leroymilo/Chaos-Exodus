class_name Biome
extends Resource

static var rng = RandomNumberGenerator.new()

@export var types: Array[String]
@export var weights: Array[float]
var cum_weights: Array[float] = []
var total: float = 0

## The p_types and p_weights arrays must have the same length
func _init(p_types: Array[String] = [], p_weights: Array[float] = []):
	assert(p_types.size() == p_weights.size(), "Invalid Biome initialization")
	if p_types.size() == 0: return
	
	types = p_types.duplicate()
	weights = p_weights.duplicate()
	self.pre_compute()

func pre_compute():
	cum_weights.append(weights[0])
	for i in range(1, weights.size()):
		cum_weights.append(cum_weights[-1] + weights[i])
	total = cum_weights[-1]

func get_type_name() -> String :
	assert(types.size() > 0, "Biome not initialized")
	
	if total == 0: pre_compute()
	
	var value = rng.randf_range(0, total)
	for i in range(cum_weights.size()):
		if value <= cum_weights[i]:
			return types[i]
	
	# to avoid "no value returned" error, shouldn't happen
	print("Generated value out of range!")
	return types[0]
