class_name TileTypeTable
extends Node

const PATH = "res://resource/tile_types/"
const EXT = ".tres"

static var list: Array[String] = []
static var table: Dictionary = {}

static func _static_init():
	var dir = DirAccess.open(PATH)
	if dir:
		for file_type_name in dir.get_files():
			var type = ResourceLoader.load(PATH + file_type_name)
			table[type.name] = type
	
	list.resize(table.size())
	for key in table.keys():
		list[table[key].id] = key

static func has(type_name: String) -> bool:
	return table.has(type_name)

static func get_type(key):
	if key is int:
		key = list[key]
	if key is String:
		return table[key]

static func add_type(type_name: String):
	table[type_name] = TileType.new().init(list.size(), type_name)
	list.append(type_name)

static func remove_type(index: int):
	var type_name = list[index]
	list.pop_at(index)
	table.erase(type_name)
	
	for i in range(index, list.size()):
		table[list[i]].id = i

static func save_type(type_name: String) -> bool:
	if not table.has(type_name): return false
	var type = table[type_name]
	
	ResourceSaver.save(
		type,
		PATH + type_name + EXT
	)
	return true

static func save():
	for name_ in list:
		save_type(name_)
	
	print("Saved Tile Types Successfully!")
	
	var dir = DirAccess.open(PATH)
	if not dir: return
	
	for file_name in dir.get_files():
		if file_name.get_extension() == EXT.substr(1): continue
		var key = file_name.trim_suffix(EXT)
		if table.has(key): continue
		dir.remove(file_name)
