extends PanelContainer

const ToolEditor = preload("res://editor/tiles/tool_editor.tscn")

signal remove(id: int, panel: PanelContainer)
signal error_message(msg: String)

@onready var delay = $Container/DelayCont/Delay
@onready var vis_mod = $Container/VisModCont/VisMod
@onready var next_state = $Container/NextStateCont/NextState

@onready var tools = $Container/Tools

var id: int
var trav_opt: TraversalOption

func init(p_trav_opt: TraversalOption):
	trav_opt = p_trav_opt
	set_id(trav_opt.id)
	
	delay.value = trav_opt.delay
	vis_mod.value = trav_opt.vis_modif
	next_state.value = trav_opt.next_state
	
	for i in range(trav_opt.tools.list.size()):
		var tool_edit = ToolEditor.instantiate()
		add_tool(tool_edit, i)

func set_id(new_id: int):
	id = new_id
	$Container/Label.text = "Option %d" % (id+1)

func create_tool():
	var pos_tools: Array[String] = []
	for tool in Enums.TOOL_NAMES:
		if not trav_opt.tools.has(tool):
			pos_tools.append(tool)
	$NewToolDialog.start(pos_tools)

func on_new_tool_dialog_cancel():
	$NewToolDialog.end()

func on_new_tool_dialog_confirm(tool_name: String):
	var tool_id = trav_opt.add_tool(tool_name)
	var tool_edit = ToolEditor.instantiate()
	add_tool(tool_edit, tool_id)
	$NewToolDialog.end()

func add_tool(tool_edit: PanelContainer, tool_id: int):
	tools.add_child(tool_edit)
	tool_edit.remove.connect(remove_tool)
	tool_edit.error_message.connect(on_tool_error)
	if not tool_edit.is_node_ready():
		await tool_edit.ready
	tool_edit.init(tool_id, trav_opt)

func remove_tool(tool_id: int, tool_edit):
	trav_opt.remove_tool(tool_id)
	tools.remove_child(tool_edit)
	
	for new_id in range(tool_id, tools.get_child_count()):
		tools.get_child(new_id).set_id(new_id)

func on_tool_error(msg: String):
	error_message.emit(msg)

func on_remove():
	remove.emit(id, self)

func on_delay_changed(value):
	trav_opt.delay = roundi(value)

func on_vis_mod_changed(value):
	trav_opt.vis_modif = roundi(value)

func on_next_state_changed(value):
	trav_opt.next_state = roundi(value)
