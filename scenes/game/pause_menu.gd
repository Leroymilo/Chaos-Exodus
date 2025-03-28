extends Control

var title: PackedScene = load("res://scenes/title.tscn")

var last_control: Globals.Controller

@onready var labels: Dictionary[String, Label] = {
	"map_scale": %MapScaleValue,
	"toolbar_scale": %ToolbarScaleValue,
	"journal_scale": %JournalScaleValue,
	"grid_toggle": %GridToggleValue,
	"writing_speed": %WritingSpeedValue,
	"scroll_delay": %ScrollDelayValue
}
@onready var back_button := %Back

func open() -> void:
	last_control = Globals.has_control
	Globals.has_control = Globals.Controller.PauseMenu
	visible = true
	back_button.grab_focus()

func close() -> void:
	Globals.has_control = last_control
	visible = false

func _input(event: InputEvent) -> void:
	if Globals.has_control != Globals.Controller.PauseMenu: return
	
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		# TODO close open sub-menus instead of unpausing
		await get_tree().process_frame
		close()


func _on_scale_changed(value: float, from: String) -> void:
	match from:
		"map_scale": Globals.map_scale = roundi(value)
		"toolbar_scale": Globals.toolbar_scale = roundi(value)
		"journal_scale": Globals.journal_scale = roundi(value)
	
	labels[from].text = 'x' + str(roundi(value))

func _on_grid_toggled(toggled_on: bool) -> void:
	Globals.show_grid = toggled_on
	if toggled_on:
		labels["grid_toggle"].text = "On"
	else: labels["grid_toggle"].text = "Off"

func _on_writing_speed_schanged(value: float) -> void:
	Globals.writing_speed = roundi(value)
	labels["writing_speed"].text = str(roundi(value)) + " c/s"

func _on_scroll_delay_changed(value: float) -> void:
	Globals.scroll_delay = value
	labels["scroll_delay"].text = str(value).rpad(4,'0') + " s"

func _on_exit_to_title() -> void:
	get_tree().change_scene_to_packed(title)
