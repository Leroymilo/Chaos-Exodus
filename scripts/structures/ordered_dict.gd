class_name OrderedDict
extends Resource

@export var list: Array = []
@export var dict: Dictionary = {}

func append(key: String, item):
	assert(not dict.has(key), "Key already exists!")
	list.append(key)
	dict[key] = item

func erase(key):
	if key is int:
		assert(key < list.size(), "Index out of Bounds!")
		key = list[key]
	if key is String:
		assert(dict.has(key), "Key does not exist!")
		dict.erase(key)
		list.erase(key)

func set_(key, new_item):
	if key is int:
		assert(key < list.size(), "Index out of Bounds!")
		key = list[key]
	if key is String:
		assert(dict.has(key), "Key does not exist!")
		dict[key] = new_item

func get_(key):
	if key is int:
		assert(key < list.size(), "Index out of Bounds!")
		key = list[key]
	if key is String:
		assert(dict.has(key), "Key does not exist!")
		return dict[key]

func size() -> int:
	return list.size()

func has(key: String):
	return dict.has(key)
