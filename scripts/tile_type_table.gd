extends Resource

const TileType = preload("res://scripts/tile_type.gd")

static var data: Dictionary

static func _static_init():
	
	# reading types
	var path = "res://resource/tile_types/"
	var dir = DirAccess.open(path)
	if dir:
		for file_name in dir.get_files():
			var key = file_name.trim_suffix(".tres")
			data[key] = ResourceLoader.load(path + file_name)
	
	var type_count = data.size()
	
	# Create tile types manually here
	
	# saving new types
	if data.size() > type_count:
		for key in data:
			ResourceSaver.save(
				data[key],
				"res://resource/tile_types/%s.tres" % key
			)

static func get_type(name: String):
	return data[name]
