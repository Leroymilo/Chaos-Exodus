class_name Biome
extends Resource

# Change selection method to binary tree if there are performance issues
# https://stackoverflow.com/questions/4511331/randomly-selecting-an-element-from-a-weighted-list

static var rng = RandomNumberGenerator.new()

@export_group("DO NOT EDIT HERE")
@export var id: int
@export var name: String
@export var types: Array[TileType] = []
@export var weights: Array[float] = []
var cumul_weights: Array[float] = []
var count: int = 0

func init(p_id: int, p_name: String) -> Biome:
	id = p_id
	name = p_name
	return self

func on_load(path: String) -> Biome:
	count = types.size()
	assert(weights.size() == count, "Biome %s is invalid!" % name)
	
	cumul_weights.clear()
	cumul_weights.append(weights[0])
	for i in range(1, count):
		cumul_weights.append(
			cumul_weights[i-1] + weights[i]
		)
	return self

func add_type(type: TileType, weight: float):
	types.append(type)
	weights.append(weight)
	cumul_weights.append(weight)
	count += 1
	if count > 1: cumul_weights[-1] += cumul_weights[-2]

func remove_type(index: int):
	types.pop_at(index)
	var weight = weights.pop_at(index)
	cumul_weights.pop_at(index)
	count -= 1
	
	for i in range(index, count):
		cumul_weights[i] -= weight

func set_weight(index: int, value: float):
	var diff = value - weights[index]
	weights[index] = value
	
	for i in range(index, count):
		cumul_weights[i] += diff

func get_type() -> TileType :
	var value = rng.randf_range(0, cumul_weights[-1])
	for i in range(cumul_weights.size()):
		if value <= cumul_weights[i]:
			return types[i]
	
	# to avoid "no value returned" error, shouldn't happen
	print("Generated value out of range!")
	return types[0]

func is_valid() -> bool:
	return count > 0
