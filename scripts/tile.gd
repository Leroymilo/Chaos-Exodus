class_name Tile
extends Node2D

const scene: PackedScene = preload("res://scenes/tile.tscn")
const types: Resource = preload("res://resource/tile_type_table.tres")
const biomes: Resource = preload("res://resource/biome_table.tres")

var tile_size: Vector2 = Vector2.ZERO
var tile_pos: Vector2i = Vector2i.ZERO
var type: Resource

static func read_types():
	if types.size() > 0: return

static func instantiate(
		p_name: String,
		tile_position: Vector2i = Vector2i.ZERO,
		use_biome: bool = false
	):
	var tile: Tile = scene.instantiate()
	tile.set_type(p_name, use_biome)
	tile.set_pos(tile_position)
	return tile
 
func set_type(p_name: String, use_biome: bool):
	if (use_biome):
		p_name = biomes.get_type_name(p_name)
	type = types.get_type(p_name)
	$Sprite.texture = load("res://sprites/tiles/%s.png" % p_name)
	var t_size: Vector2 = $Sprite.texture.get_size()
	$Fog.texture.width = t_size.x
	$Fog.texture.height = t_size.y
	tile_size = t_size * scale

func set_pos(tile_position: Vector2i):
	tile_pos = tile_position
	position = tile_size * Vector2(tile_pos)
	$Fog.texture.noise.offset.x = position.x
	$Fog.texture.noise.offset.y = position.y
	print($Fog.texture.noise.offset)

func discover():
	$Fog.hide()

func _process(delta):
	$Fog.texture.noise.offset.z += delta *0.1
