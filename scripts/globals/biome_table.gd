class_name BiomeTable
extends Node

const PATH = "res://resource/biomes/"
const EXT = ".tres"

static var list: Array[String] = []
static var table: Dictionary = {}

static func _static_init():
	var dir = DirAccess.open(PATH)
	if dir:
		for file_name in dir.get_files():
			var key = file_name.trim_suffix(EXT)
			var biome: Biome = ResourceLoader.load(PATH + file_name).on_load(key)
			table[biome.name] = biome
	
	list.resize(table.size())
	for key in table.keys():
		list[table[key].id] = key

static func has(key: String):
	return table.has(key)

static func get_biome(key):
	if key is int:
		key = list[key]
	if key is String:
		return table[key]
	print("No Biome!")

static func get_type(key):
	return get_biome(key).get_type()

static func add_biome(biome_name: String):
	table[biome_name] = Biome.new().init(list.size(), biome_name)
	list.append(biome_name)

static func save_biome(biome_name: String, new_id: int = -1) -> bool:
	if not table.has(biome_name): return false
	
	var biome: Biome = table[biome_name]
	if not biome.is_valid(): return false
	
	biome.id = new_id
	ResourceSaver.save(biome, PATH + biome_name + EXT)
	return true

static func save():
	var new_list: Array[String] = []
	var id = 0
	
	for name_ in list:
		if save_biome(name_, id):
			new_list.append(name_)
			id += 1
		else:
			table.erase(name_)
	list = new_list
	
	print("Saved Biomes Successfully!")
	
	var dir = DirAccess.open(PATH)
	if not dir: return
	
	for file_name in dir.get_files():
		if file_name.get_extension() == EXT.substr(1): continue
		var key = file_name.trim_suffix(EXT)
		if table.has(key): continue
		dir.remove(file_name)
