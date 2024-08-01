extends Control

const StateEditor = preload("res://editor/tiles/state_editor.tscn")

const NEW_TYPE_TEXT = "New Tile Type"

const NAME_FORMAT_ERROR = "The name can only contain:\n- lowercase letters\n- numbers\n- underscores."
const NAME_EXISTS_ERROR = "This type name is already used."

signal error_message(msg: String)

var last_type_index = -1
var type: TileType

var type_name_regex = RegEx.new()

@onready var type_selector = $Margins/VContainer/TypeSelectContainer/TypeSelector

@onready var state = $Margins/VContainer/HContainer/BaseProperties/StateCont/State
@onready var visibility = $Margins/VContainer/HContainer/BaseProperties/VisCont/Visibility

@onready var base_layers = $Margins/VContainer/HContainer/BaseProperties/Scroll/BaseLayers

@onready var states = $Margins/VContainer/HContainer/StatesContainer/Scroll/States

# Called when the node enters the scene tree for the first time.
func _ready():
	set_tile_types()
	type_name_regex.compile("^[a-z0-9_]+$")

func set_tile_types():
	var last_type_name: String = ""
	if last_type_index != -1:
		last_type_name = type_selector.get_item_text(last_type_index)
	var to_load: int = 0
	
	type_selector.clear()
	for i in range(TileTypeTable.list.size()):
		var key = TileTypeTable.list[i]
		if key == last_type_name:
			to_load = i
		type_selector.add_item(key)
		
	type_selector.add_item(NEW_TYPE_TEXT)
	
	if TileTypeTable.list.size() == 0:
		initialize_new_type()
	else:
		type_selector.select(to_load)
		load_type_data(to_load)

func on_tile_type_selected(index):
	var type_name = type_selector.get_item_text(index)
	
	if type_name == NEW_TYPE_TEXT:
		initialize_new_type()
	else:
		load_type_data(index)

func initialize_new_type():
	$NewTypeDialog.start()

func load_type_data(index: int):
	type = TileTypeTable.get_type(index)
	
	# cleaning states
	for child in states.get_children():
		states.remove_child(child)
	
	# loading states
	for i in range(type.states.size()):
		var state_edit = StateEditor.instantiate()
		add_state(state_edit, type.states[i])
	
	# TODO: load base layers
	
	# loading stuff
	state.value = type.state
	visibility.value = type.visibility
	
	last_type_index = index

func on_new_type_dialog_confirm(type_name: String):
	# Checking name validity
	if not type_name_regex.search(type_name):
		$NewTypeDialog.set_error(NAME_FORMAT_ERROR)
		return
	if TileTypeTable.has(type_name):
		$NewTypeDialog.set_error(NAME_EXISTS_ERROR)
		return
	
	TileTypeTable.add_type(type_name)
	
	# Adjusting Selector
	var index = type_selector.selected
	type_selector.set_item_text(index, type_name)
	type_selector.add_item(NEW_TYPE_TEXT)
	
	load_type_data(index)
	create_state()
	$NewTypeDialog.end()

func on_new_type_dialog_cancel():
	if last_type_index == -1:
		$NewTypeDialog.set_error("Cannot Cancel")
		return
	
	type_selector.select(last_type_index)
	$NewTypeDialog.end()

func save():
	TileTypeTable.save()
	set_tile_types()

func create_state():
	var new_state = type.add_state()
	var state_edit = StateEditor.instantiate()
	add_state(state_edit, new_state)

func add_state(state_edit: PanelContainer, tile_state: TileState):
	states.add_child(state_edit)
	state_edit.remove.connect(remove_state)
	state_edit.error_message.connect(on_state_error)
	if not state_edit.is_node_ready():
		await state_edit.ready
	state_edit.init(tile_state)

func remove_state(state_id: int, state_edit: PanelContainer):
	type.remove_state(state_id)
	states.remove_child(state_edit)
	
	for new_id in range(state_id, states.get_child_count()):
		states.get_child(new_id).set_id(new_id)

func on_state_error(msg: String):
	error_message.emit(msg)

func on_state_changed(value):
	type.state = roundi(value)

func on_vis_changed(value):
	type.visibility = roundi(value)

func on_remove():
	TileTypeTable.remove_type(type_selector.selected)
