extends PanelContainer

signal remove(id: int, panel: PanelContainer)
signal error_message(msg: String)

var id: int
var trav_op: TraversalOption
var tool: String

func init(p_id: int, p_trav_op: TraversalOption):
	trav_op = p_trav_op
	tool = trav_op.get_tool_name(id)
	set_id(p_id)
	
	$Container/Tool.text = tool
	$Container/Count.value = trav_op.tools.get_(tool)

func set_id(new_id: int):
	id = new_id

func on_remove():
	remove.emit(id, self)

func on_count_changed(value):
	trav_op.tools.set_(tool, roundi(value))
