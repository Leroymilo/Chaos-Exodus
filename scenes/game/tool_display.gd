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

var tool: Globals.Tool:
	set(value):
		if not is_node_ready(): await ready
		
		tool = value
		var tool_name: String = Globals.Tool.find_key(tool).to_lower()
		var texture_path := "res://assets/icons/tools/{0}.png".format([tool_name])
		icon.texture = load(texture_path)
		
		if tool == Globals.Tool.Time_:
			digit_count = 4
		else: digit_count = 3
		
		if Globals.player.tools.has(tool):
			set_count_text(Globals.player.tools[tool])
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
	if action.tools.has(tool):
		value = action.tools[tool]
	else: value = 0
	
	if value == 0:
		change.text = ""
		return
	
	change.modulate = get_color(value)
	set_change_text(value)

func update_count() -> void:
	if not Globals.player.tools.has(tool):
		hide()
		return
	
	var true_count = Globals.player.tools[tool]
	
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

func start_blink(p_tool: Globals.Tool) -> void:
	if p_tool == tool:
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
	if tool == Globals.Tool.Time_:
		return Color.RED
	else:
		if value_a < value_b:
			return Color.RED
		else:
			return Color.GREEN
