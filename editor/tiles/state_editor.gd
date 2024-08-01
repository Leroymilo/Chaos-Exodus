extends PanelContainer

const TravOptEdit = preload("res://editor/tiles/trav_opt_editor.tscn")

signal remove(id: int, panel: PanelContainer)
signal error_message(msg: String)

@onready var obstruction = $Scroll/Container/ObstructCont/Obstruction

@onready var layers_cont = $Scroll/Container/LayersCont
@onready var layers = $Scroll/Container/LayersCont/Layers

@onready var trav_opts_cont = $Scroll/Container/TravOptsCont
@onready var trav_opts = $Scroll/Container/TravOptsCont/TravOpts

var id: int
var state: TileState

func _ready():
	$Scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO

func init(p_state: TileState):
	state = p_state
	set_id(state.id)
	
	obstruction.value = state.obstruction
	
	for i in range(state.layer_paths.size()):
		pass
		# TODO
	
	for i in range(state.traversal_options.size()):
		var trav_opt = state.traversal_options[i]
		var trav_opt_edit = TravOptEdit.instantiate()
		add_trav_opt(trav_opt_edit, trav_opt)

func set_id(new_id: int):
	id = new_id
	$Scroll/Container/Label.text = "State %d" % id

func create_trav_opt():
	var new_trav_opt = state.add_trav_opt()
	var trav_opt_edit = TravOptEdit.instantiate()
	add_trav_opt(trav_opt_edit, new_trav_opt)

func add_trav_opt(trav_opt_edit: PanelContainer, trav_opt: TraversalOption):
	trav_opts.add_child(trav_opt_edit)
	trav_opt_edit.remove.connect(remove_trav_opt)
	trav_opt_edit.error_message.connect(on_trav_opt_error)
	if not trav_opt_edit.is_node_ready():
		await  trav_opt_edit.ready
	trav_opt_edit.init(trav_opt)

func remove_trav_opt(trav_opt_id: int, trav_opt_edit: PanelContainer):
	state.remove_trav_opt(trav_opt_id)
	trav_opts.remove_child(trav_opt_edit)
	
	for new_id in range(trav_opt_id, trav_opts.get_child_count()):
		trav_opts.get_child(new_id).set_id(new_id)

func on_trav_opt_error(msg: String):
	error_message.emit(msg)

func on_obstruction_changed(value):
	state.obstruction = roundi(value)

func on_remove():
	remove.emit(id, self)
