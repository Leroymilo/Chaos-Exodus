extends Control

const ToolDisplay := preload("res://scenes/game/tool_display.tscn")

@onready var map := %Map
@onready var journal := %Journal
@onready var tools := %Tools
@onready var action_desc := %ActionDesc
@onready var anim_player := $AnimationPlayer

var tool_map: Dictionary[Globals.Tool, GridContainer] = {}

func _ready() -> void:
	Globals.player = map.get_node("%Player")
	Globals.player.tile_pos = Globals.save_data.position
	Globals.player.tools = Globals.save_data.tools
	map.region = Globals.save_data.region
	
	for tool in Globals.Tool.values():
		var new_tool = ToolDisplay.instantiate()
		new_tool.tool = tool
		if not Globals.player.tools.has(tool):
			new_tool.hide()
		tools.add_child(new_tool)
		tool_map[tool] = new_tool
	
	# map settings
	var vp: SubViewport = map.get_parent()
	vp.size = vp.size_2d_override * Globals.map_scale
	
	# journal settings
	vp = journal.get_parent()
	vp.size = vp.size_2d_override * Globals.journal_scale
	
	# toolbar settings
	action_desc.add_theme_font_size_override("font_size", Globals.TEXT_MIN_SCALE * Globals.tool_bar_scale)
	Globals.show_action.connect(show_action_desc)
	
	journal.open_to_last()

func show_action_desc(action: Action) -> void:
	action_desc.text = action.description

func open_journal(value: bool) -> void:
	if value:
		Globals.has_control = Globals.Controller.Journal
		anim_player.play("journal_in")
	else:
		Globals.has_control = Globals.Controller.Map
		anim_player.play("journal_out")
