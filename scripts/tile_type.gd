extends Resource

@export var vis: int	# Visibility
@export var obstruct: int	# Visibility Obstruction
@export_flags("Free", "Torch", "Machete", "Ropes") var tools = 0
@export var delay: int

func _init(p_vis: int, p_obstruct: int, p_delay: int, p_tools: int):
	vis = p_vis
	obstruct = p_obstruct
	tools = p_tools
	delay = p_delay
