@tool
extends Node2D
class_name Tile

@onready var layers: Node2D = $Layers
@onready var grid: Sprite2D = $Grid

@export var type: TileType = null:
	set(value):
		if not is_node_ready(): await ready
		
		if type != null:
			for child in layers.get_children():
				layers.remove_child(child)
		
		# TODO: probably handle biomes here.
		
		type = value
		if type != null:
			make_layers()

func _ready() -> void:
	if not Engine.is_editor_hint():
		Globals.show_grid_changed.connect(show_grid)

func make_layers() -> void:
	for layer in type.layers:
		
		# TODO: handle layer conditions here.
		
		make_layer(layer)

func make_layer(layer_data: TileLayer) -> void:
	var layer = Sprite2D.new()
	#print(type.get_property_list())
	layer.texture = type.sprite_sheet
	layer.hframes = type.frames.x
	layer.vframes = type.frames.y
	layer.frame_coords.y = layer_data.row
	
	layer.centered = false
	layer.offset = Vector2(-8, -16)
	
	layer.z_index = layer_data.z_index
	layer.z_as_relative = false
	
	layers.add_child(layer)

func show_grid(value: bool) -> void:
	if value: grid.show()
	else: grid.hide()
