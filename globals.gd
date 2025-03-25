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
	Torch, Machete, Rope
}

# Settings

var map_scale := 2
var journal_scale := 2
var tool_bar_scale := 2

signal show_grid_changed(show: bool)
var show_grid := true:
	set(value):
		show_grid = value
		show_grid_changed.emit(value)

var sort_by_last_used := true

var writing_speed := 40

# Global Variables

var player: Player
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
