extends Control

var title: PackedScene = load("res://scenes/title.tscn")

var last_control: Globals.Controller

func open() -> void:
	last_control = Globals.has_control
	Globals.has_control = Globals.Controller.PauseMenu
	visible = true

func close() -> void:
	Globals.has_control = last_control
	visible = false

func _input(event: InputEvent) -> void:
	if Globals.has_control != Globals.Controller.PauseMenu: return
	
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		# TODO close open sub-menus instead of unpausing
		await get_tree().process_frame
		close()


func _on_scale_changed(value: float, from: int) -> void:
	match from:
		0: Globals.map_scale = roundi(value)
		1: Globals.tool_bar_scale = roundi(value)
		2: Globals.journal_scale = roundi(value)

func _on_grid_toggled(toggled_on: bool) -> void:
	Globals.show_grid = toggled_on

func _on_writing_speed_schanged(value: float) -> void:
	Globals.writing_speed = roundi(value)

func _on_exit_to_title() -> void:
	get_tree().change_scene_to_packed(title)
