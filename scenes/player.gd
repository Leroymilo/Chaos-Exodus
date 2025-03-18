extends Node2D
class_name Player

signal  target_moved()

@export var id: int = 0
@export var color: Color
var tile_pos := Vector2i.ZERO:
	set(value):
		tile_pos = value
		position = value * Globals.TILE_SIZE

@onready var cursor = %Cursor
@onready var arrows = %Arrows
@onready var on_target = %OnTarget
@onready var no_action = %NoAction
@onready var act_indic = %Indicator

var tools: Dictionary[Globals.Tool, int] = {}

var target := Vector2i.ZERO:
	set(value):
		on_target.position = Globals.TILE_SIZE * value
		target = value
		
		if target == Vector2i.ZERO:
			arrows.hide()
		else:
			arrows.frame_coords.y = Globals.DIRS[target]
			arrows.show()
		
		target_moved.emit()

func move_target(direction: Vector2i) -> void:
	if target + direction == Vector2i.ZERO:
		target = Vector2i.ZERO
	else:
		var new_target = tile_pos + direction
		if new_target.x < 0 or new_target.y < 0 or new_target.y > 4:
			target = Vector2i.ZERO
		else:
			target = direction

func get_target() -> Vector2i:
	return target + tile_pos

func anim_step() -> void:
	cursor.frame_coords.x = (cursor.frame_coords.x + 1) % cursor.hframes
	arrows.frame_coords.x = (arrows.frame_coords.x + 1) % arrows.hframes

func is_moving() -> bool:
	return target != Vector2i.ZERO

func try_act(tile: Tile) -> bool:
	var move := is_moving()
	
	if not tile.type.use_action(move):
		return false
		
	if move:
		tile_pos += target
		target = Vector2i.ZERO
	return true

func set_action_indicator(total: int, index: int = 0):
	if total == 0:
		no_action.show()
		act_indic.hide()
	else:
		act_indic.text = "{0}/{1}".format([index+1, total])
		no_action.hide()
		act_indic.show()

func _ready() -> void:
	cursor.modulate = color
	arrows.modulate = color
