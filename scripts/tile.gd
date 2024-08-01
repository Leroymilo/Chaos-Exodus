extends Node2D

var tile_pos: Vector2i = Vector2i.ZERO
var tile_size: Vector2 = Vector2.ZERO
var type: Resource

func set_type(p_name: String, use_biome: bool):
	if (use_biome):
		type = BiomeTable.get_type(p_name)
	else:
		type = TileTypeTable.get_type(p_name)
	
	$Sprite.texture = load(type.sprite_sheet_path)
	var t_size: Vector2 = $Sprite.texture.get_size()
	$Fog.texture.width = t_size.x
	$Fog.texture.height = t_size.y
	tile_size = t_size * scale

func set_pos(tile_position: Vector2i):
	tile_pos = tile_position
	position = tile_size * Vector2(tile_pos)
	$Fog.texture.noise.offset.x = position.x
	$Fog.texture.noise.offset.y = position.y

func discover():
	$Fog.hide()

func _process(delta):
	$Fog.texture.noise.offset.z += delta * 4
