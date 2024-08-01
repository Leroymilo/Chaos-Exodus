extends PanelContainer

signal remove_tile_type(type_index: int, type_option: Node)

@onready var tile_type = $VBoxContainer/Label
@onready var weight = $VBoxContainer/Weight/SpinBox

var id: int
var biome: Biome

func _ready():
	var i = 0

func init(p_id: int, p_biome: Biome = null):
	id = p_id
	if p_biome != null: biome = p_biome
	tile_type.text = biome.types[id].name

func create(p_id: int, p_biome: Biome):
	init(p_id, p_biome)
	
	biome.add_type(
		TileTypeTable.get_type(0),
		weight.value
	)

func load_from(p_id: int, p_biome: Biome):
	init(p_id, p_biome)
	
	weight.value = biome.weights[id]

func on_weight_changed(value):
	biome.weights[id] = value

func remove():
	remove_tile_type.emit(id, self)
