extends Node

# Constants

const TILE_SIZE := Vector2i(64, 64)
const DIRS := {
	Vector2i.UP: 0, Vector2i.RIGHT: 1,
	Vector2i.DOWN: 2, Vector2i.LEFT: 3
}
const TEXT_MIN_SCALE := 12

enum Tool {
	Time_, Energy, Morale,
	Torch, Machete, Rope
}

# Settings

var map_scale := 3
var journal_scale := 2
var UI_scale := 3

signal show_grid_changed(show: bool)
var show_grid := true:
	set(value):
		show_grid = value
		show_grid_changed.emit(value)

var sort_by_last_used := true

# Global Variables

var player: Player
var save_data: SaveData
var to_blink: Array[Tool] = []
