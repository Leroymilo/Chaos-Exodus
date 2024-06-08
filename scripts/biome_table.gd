extends Resource

#const Biome = preload("res://scripts/biome.gd")
const types: Resource = preload("res://resource/tile_type_table.tres")

static var data: Dictionary

static func _static_init():
	# reading types
	var path = "res://resource/biomes/"
	var dir = DirAccess.open(path)
	if dir:
		for file_name in dir.get_files():
			var key = file_name.trim_suffix(".tres")
			print(path + file_name)
			data[key] = ResourceLoader.load(path + file_name, "Biome")
	
	var type_count = data.size()
	
	# Create tile types manually here
	#data["jungle"] = Biome.new(
		#["forest", "jungle"],
		#[1, 5]
	#)
	
	# saving new types
	if data.size() > type_count:
		for key in data:
			ResourceSaver.save(
				data[key],
				"res://resource/biomes/%s.tres" % key
			)

static func get_type_name(biome_name: String):
	return data[biome_name].get_type_name()
