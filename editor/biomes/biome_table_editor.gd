extends Control

const TileTypeOp = preload("res://editor/biomes/tile_type_option.tscn")

const NEW_BIOME_TEXT = "New Biome"

const NAME_FORMAT_ERROR = "The name can only contain:\n- lowercase letters\n- numbers\n- underscores."
const NAME_EXISTS_ERROR = "This type name is already used."

@onready var biome_selector: OptionButton = $Margins/HContainer/VContainer/BiomeSelector
@onready var type_container: HFlowContainer = $Margins/HContainer/TileTypes
var last_biome_index = -1
var biome: Biome

var biome_name_regex = RegEx.new()

func _ready():
	biome_selector.clear()
	for key in BiomeTable.list:
		biome_selector.add_item(key)
	biome_selector.add_item(NEW_BIOME_TEXT)
	
	if BiomeTable.list.size() == 0:
		initialize_new_biome()
	else:
		load_biome(0)
	
	biome_name_regex.compile("^[a-z0-9_]+$")

func on_biome_selected(index):
	var biome_name = biome_selector.get_item_text(index)
	
	if biome_name == NEW_BIOME_TEXT:
		initialize_new_biome()
	else:
		load_biome(index)

func initialize_new_biome():
	$NewBiomeDialog/VBoxContainer/TextEdit.text = ""
	$NewBiomeDialog.visible = true

func load_biome(index: int):
	biome = BiomeTable.get_biome(index)
	
	for child in type_container.get_children():
		type_container.remove_child(child)
	
	for i in range(biome.count):
		var new_type = TileTypeOp.instantiate()
		await add_tile_type(new_type)
		new_type.load_from(i, biome)
	
	last_biome_index = index

func on_new_biome_dialog_confirm():
	var biome_name: String = $NewBiomeDialog/VBoxContainer/TextEdit.text
	
	# Checking name validity
	if not biome_name_regex.search(biome_name):
		$NewBiomeDialog/VBoxContainer/ErrorMsg.text = NAME_FORMAT_ERROR
		return
	if BiomeTable.has(biome_name):
		$NewBiomeDialog/VBoxContainer/ErrorMsg.text = NAME_EXISTS_ERROR
		return
	$NewBiomeDialog/VBoxContainer/ErrorMsg.text = ""
	
	BiomeTable.add_biome(biome_name)
	
	# Adjusting Selector
	var index = biome_selector.selected
	biome_selector.set_item_text(index, biome_name)
	biome_selector.add_item(NEW_BIOME_TEXT)
	
	load_biome(index)
	$NewBiomeDialog.visible = false

func on_new_biome_dialog_cancel():
	biome_selector.select(last_biome_index)
	$NewBiomeDialog.visible = false

func save():
	BiomeTable.save()
	_ready()

func create_tile_type():
	if biome_selector.selected == -1: return
	
	var new_type: Node = TileTypeOp.instantiate()
	await add_tile_type(new_type)
	new_type.create(type_container.get_child_count() - 1, biome)

func add_tile_type(new_type: Node):
	type_container.add_child(new_type)
	new_type.remove_tile_type.connect(remove_tile_type)
	if not new_type.is_node_ready():
		await new_type.ready

func remove_tile_type(type_index: int, type_option: Node):
	type_container.remove_child(type_option)
	
	for i in range(type_index, type_container.get_child_count()):
		type_container.get_child(i).init(i)
	
	biome.remove_type(type_index)
