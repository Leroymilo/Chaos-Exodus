extends Node2D
class_name Chaos

signal chaos_moved()

@onready var wave := $Wave
@onready var distance := %Distance
@onready var count := %Count

var offset: int
var tile_pos := 0
var time_cache := 0
var step_count := 5:
	set(value):
		step_count = value
		if step_count == 0: hide()
		else: show()
		update_count()
var cur_step := 0:
	set(value):
		cur_step = value
		update_count()

func _ready() -> void:
	tile_pos = Globals.save_data.state.chaos_pos
	cur_step = Globals.save_data.state.chaos_step
	
	Globals.update_tools.connect(time_changed)

func _process(delta: float) -> void:
	if step_count == 0: return
	var diff = get_target_pos() - wave.position.x
	wave.position.x += diff * exp( -delta * 100)
	distance.visible = tile_pos + offset < 0
	distance.text = "< " + str(-tile_pos - offset)

func get_target_pos() -> float:
	return Globals.TILE_SIZE.x * (tile_pos + float(cur_step)/step_count)

func time_changed() -> void:
	if step_count == 0: return
	var true_time: int = Globals.player.tools[Tool.time.name]
	if true_time == time_cache: return
	
	cur_step += true_time - time_cache
	if cur_step >= step_count:
		tile_pos += cur_step / step_count
		cur_step = cur_step % step_count
		chaos_moved.emit()
	
	time_cache = true_time
	count.text = "{0}/{1}".format([cur_step, step_count])

func update_count():
	count.text = "{0}/{1}".format([cur_step, step_count])
