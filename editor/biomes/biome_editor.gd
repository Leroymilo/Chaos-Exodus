extends PanelContainer

const TypeEdit = preload("res://editor/biomes/tile_type_option.tscn")

signal remove(biome_id: int, panel: PanelContainer)
signal error_message(msg: String)

@onready var types = $Scroll/VContainer/TileTypes

var biome: Biome

func _ready():
	$Scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO

func init(p_biome: Biome):
	biome = p_biome
	$Scroll/VContainer/Label.text = biome.name
	load_types()

func load_types():
	for child in types.get_children():
		types.remove_child(child)
	
	for i in range(biome.types.size()):
		add_type()

func initialize_new_type():
	var pos_types: Array[String] = []
	for type in TileTypeTable.table.values():
		if not biome.types.has(type):
			pos_types.append(type.name)
	if pos_types.size() == 0:
		error_message.emit("All Tile Types are already used in this Biome.")
		return
	
	$AddTypeDialog.start(pos_types)

func on_add_type_dialog_cancel():
	$AddTypeDialog.end()

func create_type(type_name: String):
	biome.add_type(
		TileTypeTable.get_type(type_name),
		1
	)
	add_type()
	$AddTypeDialog.end()

func add_type():
	var type_edit = TypeEdit.instantiate()
	types.add_child(type_edit)
	type_edit.remove.connect(remove_type)
	type_edit.error_message.connect(on_type_error)
	if not type_edit.is_node_ready():
		await type_edit.ready
	type_edit.init(types.get_child_count() - 1, biome)

func remove_type(type_index: int, type_edit: PanelContainer):
	biome.remove_type(type_index)
	types.remove_child(type_edit)
	
	for new_id in range(type_index, types.get_child_count()):
		types.get_child(new_id).set_id(new_id)

func on_type_error(msg: String):
	error_message.emit(msg)

func on_remove():
	remove.emit(biome.id, self)
