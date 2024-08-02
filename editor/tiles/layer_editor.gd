extends PanelContainer

signal remove(id: int, panel: PanelContainer)
signal move(id: int, panel: PanelContainer, down: bool)

var id: int
var type: TileType = null
var state: TileState = null

@onready var image = $VContainer/HContainer/TextureRect
@onready var up = $VContainer/HContainer/Move/Up
@onready var down = $VContainer/HContainer/Move/Down

func init(p_id: int, p_type = null, p_state = null):
	set_id(p_id)
	if p_type != null: type = p_type
	if p_state != null: state = p_state
	
	image.texture = load(get_image_path())

func set_id(new_id: int):
	id = new_id
	up.disabled = id == 0

func disable_down(new_val: bool):
	down.disabled = new_val

func get_image_path() -> String:
	if type != null:
		return type.base_layer_paths[id]
	if state != null:
		return state.layer_paths[id]
	assert(false, "Layer Editor not initialized!")
	return ""

func on_remove():
	remove.emit(id, self)

func on_move_up():
	move.emit(id, self, false)

func on_move_down():
	move.emit(id, self, true)
