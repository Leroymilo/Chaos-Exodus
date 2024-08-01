extends Control

const BiomeEdit = preload("res://editor/biomes/biome_editor.tscn")

const NAME_FORMAT_ERROR = "The name can only contain: lowercase letters, numbers, underscores."
const NAME_EXISTS_ERROR = "This biome name is already used."

signal error_message(msg: String)

@onready var biomes = $Margins/HContainer/Scroll/Biomes

var biome_name_regex = RegEx.new()

func _ready():
	load_biomes()
	biome_name_regex.compile("^[a-z0-9_]+$")

func load_biomes():
	for child in biomes.get_children():
		biomes.remove_child(child)
	
	for i in range(BiomeTable.list.size()):
		var biome = BiomeTable.get_biome(i)
		add_biome(biome)

func initialize_new_biome():
	$NewBiomeDialog.start()

func on_new_biome_dialog_confirm(biome_name: String):
	# Checking name validity
	if not biome_name_regex.search(biome_name):
		error_message.emit(NAME_FORMAT_ERROR)
		return
	if BiomeTable.has(biome_name):
		error_message.emit(NAME_EXISTS_ERROR)
		return
	
	create_biome(biome_name)
	
	$NewBiomeDialog.end()

func on_new_biome_dialog_cancel():
	$NewBiomeDialog.end()

func create_biome(biome_name: String):
	var new_biome = BiomeTable.add_biome(biome_name)
	add_biome(new_biome)

func add_biome(biome: Biome):
	var biome_edit = BiomeEdit.instantiate()
	biomes.add_child(biome_edit)
	biome_edit.remove.connect(remove_biome)
	biome_edit.error_message.connect(on_biome_error)
	if not biome_edit.is_node_ready():
		await biome_edit.ready
	biome_edit.init(biome)

func remove_biome(biome_id: int, biome_edit: PanelContainer):
	BiomeTable.remove_biome(biome_id)
	biomes.remove_child(biome_edit)
	
	for new_id in range(biome_id, biomes.get_child_count()):
		biomes.get_child(new_id).set_id(new_id)

func on_biome_error(msg: String):
	error_message.emit(msg)

func save():
	BiomeTable.save()
	load_biomes()
