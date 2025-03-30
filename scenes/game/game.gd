extends Control

const ToolDisplay := preload("res://scenes/game/tool_display.tscn")

@onready var map := %Map
@onready var journal := %Journal
@onready var tools := %Tools
@onready var action_desc := %ActionDesc
@onready var pause_menu := $PauseMenu
@onready var anim_player := $AnimationPlayer

func _ready() -> void:
	map.region = Globals.save_data.region
	
	for tool in Globals.save_data.scenario.tools:
		var new_tool = ToolDisplay.instantiate()
		new_tool.tool = tool
		if not Globals.player.tools.has(tool.name):
			new_tool.hide()
		tools.add_child(new_tool)
	
	Globals.show_action.connect(show_action_desc)
	Globals.map_scale_changed.connect(update_scales)
	Globals.toolbar_scale_changed.connect(update_scales)
	Globals.journal_scale_changed.connect(update_scales)
	
	update_scales()
	
	journal.open_to_last()

func update_scales() -> void:
	# map
	var vpc: SubViewportContainer = map.get_parent().get_parent()
	vpc.scale = Vector2.ONE * Globals.map_scale
	
	# journal
	var vp: SubViewport = journal.get_parent()
	vp.size = vp.size_2d_override * Globals.journal_scale
	
	# action description
	action_desc.add_theme_font_size_override(
		"font_size", Globals.TEXT_MIN_SCALE * Globals.toolbar_scale)

func show_action_desc(action: Action) -> void:
	action_desc.text = action.description

func open_journal(value: bool) -> void:
	if value:
		Globals.has_control = Globals.Controller.Journal
		anim_player.play("journal_in")
	else:
		Globals.has_control = Globals.Controller.Map
		anim_player.play("journal_out")
		map._on_player_target_moved()

func _input(event: InputEvent) -> void:
	if Globals.has_control == Globals.Controller.Map:
		if event.is_action_pressed("open_journal"):
			await get_tree().process_frame
			journal.open_to_last()
		
		elif event.is_action_pressed("ui_cancel"):
			await get_tree().process_frame
			pause_menu.open()

	if Globals.has_control != Globals.Controller.PauseMenu:
		if event.is_action_pressed("pause"):
			await get_tree().process_frame
			pause_menu.open()
