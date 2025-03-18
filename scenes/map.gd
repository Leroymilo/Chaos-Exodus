@tool
extends SubViewport

signal update_tools()
signal missing_tools()
signal show_action(action: Action)

const TileScene: PackedScene = preload("res://scenes/tile.tscn")

@onready var tiles := $Tiles

@export var region: Region = null:
	set(value):
		if not is_node_ready(): await ready
		
		if region != null:
			for child in tiles.get_children():
				tiles.remove_child(child)
			tile_map.clear()
		
		region = value
		if region != null:
			make_tiles()

var tile_map: Dictionary[Vector2i, Tile]

func _ready() -> void:
	if not Engine.is_editor_hint():
		size = size_2d_override * Globals.map_scale

func make_tiles():
	for i in region.tiles.size():
		var pos := Vector2i(i/5, i%5)
		var new_tile = TileScene.instantiate()
		new_tile.type = region.tiles[i]
		new_tile.position = Globals.TILE_SIZE * pos
		tile_map[pos] = new_tile
		tiles.add_child(new_tile)

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	# Moving target

	if event.is_action_pressed("ui_up"):
		Globals.player.move_target(Vector2i.UP)
	elif event.is_action_pressed("ui_right"):
		Globals.player.move_target(Vector2i.RIGHT)
	elif event.is_action_pressed("ui_down"):
		Globals.player.move_target(Vector2i.DOWN)
	elif event.is_action_pressed("ui_left"):
		Globals.player.move_target(Vector2i.LEFT)
	elif event.is_action_pressed("ui_cancel"):
		Globals.player.target = Vector2i.ZERO
	
	 # Choosing action
	
	elif event.is_action_pressed("ui_focus_next"):
		change_action(true)
	elif event.is_action_pressed("ui_focus_prev"):
		change_action(false)
	elif event.is_action_pressed("ui_accept"):
		if Globals.player.try_act(tile_map[Globals.player.get_target()]):
			update_tools.emit()
		else: missing_tools.emit()

func change_action(next: bool) -> void:
		var tile_type := tile_map[Globals.player.get_target()].type
		var move: bool = Globals.player.is_moving()
		tile_type.change_action(next, move)
		show_action.emit(tile_type.get_action(move))

func _on_player_target_moved() -> void:
	# show moves/actions for targeted tile
	var move: bool = Globals.player.is_moving()
	var action: Action = tile_map[Globals.player.get_target()].type.get_action(move)
	show_action.emit(action)
