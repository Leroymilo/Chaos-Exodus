extends Control

@onready var day_counter := %DayCounter
@onready var entry_text := %EntryText
@onready var page_nb := %PageNumber

@export var is_left_page := true
@export var ready_to_write := false

enum INPUT_MODE {None, Turn,  Write, Choose}
var current_mode := INPUT_MODE.None
var in_event: bool:
	get():
		return current_mode == INPUT_MODE.Write or current_mode == INPUT_MODE.Choose

var until_new_scroll := 0.0
var scrolling := 0	# 1 is down, -1 is up

var data: EventSaveData
var event_id: String
var index := -1

var focused := false
var writing_start_time := 0
var chars := 0
var script_tree: ScriptTree
var branch_node: ScriptBranch

func _ready() -> void:
	if not is_left_page:
		page_nb.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	Globals.writing_speed_changed.connect(writing_speed_changed)

func load_page(p_index: int) -> void:
	index = p_index
	page_nb.text = str(index)
	if Globals.save_data.events_order.size() <= index:
		# out of bound event id
		data = null
		day_counter.text = ""
		entry_text.text = ""
		current_mode = INPUT_MODE.None
		return
	
	event_id = Globals.save_data.events_order[index]
	data = Globals.save_data.events_data[event_id]
	
	day_counter.text = "Day {0}".format([data.get_turn()])
	
	if data.finished:
		entry_text.text = data.finished_text
		current_mode = INPUT_MODE.Turn
		return
	
	write_page()

func change_page(forward: bool) -> void:
	if forward:
		load_page(index+2)
	else:
		load_page(index-2)

func write_page() -> void:
	current_mode = INPUT_MODE.Write
	var script_path: String = data.script_queue.front()
	chars = 0
	writing_start_time = -1
	ScriptBase.branch_nodes.clear()
	script_tree = ScriptTree.new()
	var file = FileAccess.open(script_path, FileAccess.READ)
	script_tree.parse(file.get_as_text(true), 0)
	script_tree.end_reached.connect(script_ended)
	
	var branches_taken := data.branches
	for branch in ScriptBase.branch_nodes:
		branch.choice_started.connect(choice_started)
		branch.choice_made.connect(choice_made)
		branch.set_selection(branches_taken)

func writing_speed_changed() -> void:
	writing_start_time = Time.get_ticks_msec() - chars * 1000 / Globals.writing_speed

func choice_started(value: ScriptBranch) -> void:
	current_mode = INPUT_MODE.Choose
	branch_node = value
	value.choice_started.disconnect(choice_started)

func choice_made(branch_id: String) -> void:
	Globals.choice_taken.emit(event_id, branch_id)
	var new_path := data.take_branch(branch_id)
	if new_path != "":
		data.script_queue.append(new_path)
	writing_start_time = Time.get_ticks_msec() - chars * 1000 / Globals.writing_speed
	current_mode = INPUT_MODE.Write

func script_ended() -> void:
	data.script_queue.pop_front()
	data.finished_text = entry_text.text
	if data.script_queue.size() == 0:
		data.finished = true
		Globals.save_data.save()
		current_mode = INPUT_MODE.Turn
	else:
		Globals.save_data.save()
		write_page()

func _process(delta: float) -> void:
	if current_mode == INPUT_MODE.Write and ready_to_write:
		if writing_start_time == -1:
			writing_start_time = Time.get_ticks_msec()
		chars = (Time.get_ticks_msec() - writing_start_time)\
			* Globals.writing_speed / 1000
		update_text()
	
	if current_mode == INPUT_MODE.Choose and ready_to_write:
		update_text()
	
	if focused and scrolling != 0:
		until_new_scroll -= delta
		if until_new_scroll <= 0:
			until_new_scroll = Globals.scroll_delay
			update_scroll_bar()

func _input(event: InputEvent) -> void:
	if Globals.has_control != Globals.Controller.Journal: return
	if current_mode == INPUT_MODE.Write:
		if event.is_action_pressed("ui_accept"):
			while current_mode == INPUT_MODE.Write:
				chars += 1
				update_text()
	
	elif current_mode == INPUT_MODE.Choose:
		if branch_node.handle_event(event):
			update_text()
	
	if event.is_action_released("ui_up")\
	or event.is_action_released("ui_down"):
		scrolling = 0
	
	if focused:
		if event.is_action_pressed("ui_down") and scrolling != 1:
			scrolling = 1
			update_scroll_bar()
			until_new_scroll = 10 * Globals.scroll_delay
		elif event.is_action_pressed("ui_up") and scrolling != -1:
			scrolling = -1
			update_scroll_bar()
			until_new_scroll = 10 * Globals.scroll_delay
			entry_text.scroll_following = false

func update_scroll_bar() -> void:
	var scroll_bar: VScrollBar= entry_text.get_v_scroll_bar()
	scroll_bar.value += scrolling * 12
	if scroll_bar.value + scroll_bar.page == scroll_bar.max_value:
		entry_text.scroll_following = true

func update_text() -> void:
	entry_text.text = data.finished_text + script_tree.get_text(chars).text
