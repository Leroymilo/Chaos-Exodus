extends Node2D

const TileScene: PackedScene = preload("res://scenes/game/map/tile.tscn")
const EventScene: PackedScene = preload("res://scenes/game/map/event.tscn")

@onready var tiles := $Tiles
@onready var events := $Events

@export var region: Region = null:
	set(value):
		if not is_node_ready(): await ready
		
		if region != null:
			for child in tiles.get_children():
				tiles.remove_child(child)
			tile_map.clear()
			for child in events.get_children():
				events.remove_child(child)
			event_map.clear()
		
		region = value
		if region != null:
			make_tiles()
			make_events()
			Globals.chaos.step_count = region.chaos_delay

var tile_map: Dictionary[Vector2i, Tile]
var event_map: Dictionary[Vector2i, Event]
var offset := 0

func _ready() -> void:
	Globals.player = %Player
	Globals.chaos = %Chaos
	Globals.chaos.time_cache = Globals.player.tools[Tool.time.name]
	
	var pos = Globals.player.tile_pos
	offset = clamp(offset,
		-(pos.x - Globals.PLAYER_RANGE.x),
		-(pos.x - Globals.PLAYER_RANGE.y))
	Globals.chaos.offset = offset
	position.x = offset * Globals.TILE_SIZE.x

func make_tiles():
	for i in region.tiles.size():
		var pos := Vector2i(i/5, i%5)
		var new_tile = TileScene.instantiate()
		new_tile.type = region.tiles[i]
		new_tile.position = Globals.TILE_SIZE * pos
		tile_map[pos] = new_tile
		tiles.add_child(new_tile)

func make_events():
	for pos in region.events.keys():
		var new_event = EventScene.instantiate()
		new_event.data = region.events[pos]
		if new_event.triggered: continue	# skipping already triggered event
		new_event.position = Globals.TILE_SIZE * pos
		event_map[pos] = new_event
		events.add_child(new_event)

func _process(delta: float) -> void:
	var diff = offset * Globals.TILE_SIZE.x - position.x
	position.x += diff * exp( -delta * 100)

func _input(event: InputEvent) -> void:
	if Globals.has_control != Globals.Controller.Map: return
	
	# Moving target
	
	if event.is_action_pressed("ui_up"):
		Globals.player.move_target(Vector2i.UP)
	elif event.is_action_pressed("ui_right"):
		Globals.player.move_target(Vector2i.RIGHT)
	elif event.is_action_pressed("ui_down"):
		Globals.player.move_target(Vector2i.DOWN)
	elif event.is_action_pressed("ui_left"):
		Globals.player.move_target(Vector2i.LEFT)
	
	 # Choosing action
	
	elif event.is_action_pressed("ui_focus_next"):
		change_action(true)
	elif event.is_action_pressed("ui_focus_prev"):
		change_action(false)
	elif event.is_action_pressed("ui_accept"):
		Globals.player.try_act(tile_map[Globals.player.get_target()])

func change_action(next: bool) -> void:
	var tile_type := tile_map[Globals.player.get_target()].type
	var move: bool = Globals.player.is_moving()
	tile_type.change_action(next, move)

func _on_player_target_moved() -> void:
	# show moves/actions for targeted tile
	var tile_type := tile_map[Globals.player.get_target()].type
	var move: bool = Globals.player.is_moving()
	tile_type.get_action(move)

func _on_player_moved() -> void:
	var pos = Globals.player.tile_pos
	if event_map.has(pos) and event_map[pos].triggerable:
		event_map[pos].trigger()
	offset = clamp(offset,
		-(pos.x - Globals.PLAYER_RANGE.x),
		-(pos.x - Globals.PLAYER_RANGE.y))
	Globals.chaos.offset = offset

func check_game_over() -> void:
	await get_tree().process_frame	# waits for player movement to complete
	if Globals.chaos.tile_pos > Globals.player.tile_pos.x:
		# TODO
		print("Game Over!")
