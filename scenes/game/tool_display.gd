extends GridContainer

@onready var icon: TextureRect = $Icon
@onready var count: Label = $Count
@onready var change: Label = $Change
@onready var update_timer: Timer = $UpdateTimer
@onready var blink_timer: Timer = $BlinkTimer

const ICON_SIZE := Vector2i(16, 16)

var digit_count: int = 3

const BLINK := 8
var blink_count := 0

var tool: Tool:
	set(value):
		if not is_node_ready(): await ready
		
		tool = value
		icon.texture = tool.icon
		
		digit_count = str(tool.max_val).length()
		
		if Globals.player.tools.has(tool.name):
			set_count_text(Globals.player.tools[tool.name])
		else: set_count_text(0)

func _ready() -> void:
	Globals.blink_tool.connect(start_blink)
	Globals.update_tools.connect(update_count)
	Globals.show_action.connect(show_diff)
	Globals.toolbar_scale_changed.connect(update_scale)
	update_scale()

func update_scale() -> void:
	theme.default_font_size = Globals.TEXT_MIN_SCALE * Globals.toolbar_scale
	icon.custom_minimum_size = ICON_SIZE * Globals.toolbar_scale

func show_diff(action: Action) -> void:
	var value: int
	if action.tools.has(tool.name):
		value = action.tools[tool.name]
	else: value = 0
	
	if value == 0:
		change.text = ""
		return
	
	change.modulate = get_color(value)
	set_change_text(value)

func update_count() -> void:
	if not Globals.player.tools.has(tool.name):
		hide()
		return
	
	var true_count = Globals.player.tools[tool.name]
	
	if not visible:
		set_count_text(true_count)
		show()
	
	var count_val = count.text as int
	if count_val == true_count:
		count.modulate = Color.WHITE
		return
	
	blink_timer.stop()
	
	count.modulate = get_color(true_count, count_val).lerp(Color.WHITE, 0.5)
	if count_val < true_count: count_val += 1
	else: count_val -= 1
	set_count_text(count_val)
	
	update_timer.start()

func start_blink(p_tool: String) -> void:
	if p_tool == tool.name:
		blink_count = BLINK
		blink()

func blink() -> void:
	blink_count -= 1
	if blink_count % 2 == 0:
		count.modulate = Color.WHITE
	else:
		count.modulate = Color.RED
	
	if blink_count > 0:
		blink_timer.start()

var last_state: bool = false

func set_count_text(value: int) -> void:
	count.text = str(value).lpad(digit_count, '0')

func set_change_text(value: int) -> void:
	if value > 0: change.text = "+{0}".format([value])
	else: change.text = str(value)

func get_color(value_a: int, value_b: int = 0) -> Color:
	if tool.is_good == (value_a < value_b):
		return Color.RED
	else:
		return Color.GREEN
