extends Node

# Constants

const TILE_SIZE := Vector2i(64, 64)
const DIRS := {
	Vector2i.UP: "up", Vector2i.RIGHT: "right",
	Vector2i.DOWN: "down", Vector2i.LEFT: "left"
}
const TEXT_MIN_SCALE := 12

enum Tool {
	Time_, Energy, Morale,
	Torch, Machete, Rope, Soup
}

const PLAYER_RANGE := Vector2i(1, 3)

# Settings
signal map_scale_changed()
var map_scale := 2:
	set(value):
		map_scale = value
		map_scale_changed.emit()
signal journal_scale_changed()
var journal_scale := 2:
	set(value):
		journal_scale = value
		journal_scale_changed.emit()
signal toolbar_scale_changed()
var toolbar_scale := 2:
	set(value):
		toolbar_scale = value
		toolbar_scale_changed.emit()


signal show_grid_changed(show: bool)
var show_grid := true:
	set(value):
		show_grid = value
		show_grid_changed.emit(value)

var sort_by_last_used := true

signal writing_speed_changed()
var writing_speed := 40:	# in char/s
	set(value):
		writing_speed = value
		writing_speed_changed.emit()
var scroll_delay := 0.05	# in seconds
# Global Variables

var player: Player
var chaos: Chaos
var save_data: SaveData

enum Controller {Map, Journal, PauseMenu}
var has_control := Controller.Map

# Communication Signals

@warning_ignore("unused_signal")
signal blink_tool(tool: Tool)
@warning_ignore("unused_signal")
signal update_tools()
@warning_ignore("unused_signal")
signal show_action(action: Action)

@warning_ignore("unused_signal")
signal event_triggered(event_nb: int)
@warning_ignore("unused_signal")
signal choice_taken(event_id: String, choice_id: String)
