extends Node

const TOOL_NAMES: Array[String] = ["Torch", "Machete", "Ropes"]
var TOOL_IDS: Dictionary = {}
var TOOL_PAIRS: Array[Array] = []

func _ready():
	for i in range(len(TOOL_NAMES)):
		var tool = TOOL_NAMES[i]
		TOOL_IDS[tool] = i
		TOOL_PAIRS.append([i, tool])
