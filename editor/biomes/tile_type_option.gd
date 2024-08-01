extends PanelContainer

signal remove(type_index: int, type_option: Node)
signal error_message(msg: String)

@onready var tile_type = $VBoxContainer/Label
@onready var weight = $VBoxContainer/Weight/SpinBox

var id: int
var biome: Biome

func init(p_id: int, p_biome: Biome = null):
	biome = p_biome
	set_id(p_id)
	tile_type.text = biome.types[id].name

	weight.value = biome.weights[id]

func set_id(new_id: int):
	id = new_id

func on_weight_changed(value):
	biome.set_weight(id, value)

func on_remove():
	remove.emit(id, self)
