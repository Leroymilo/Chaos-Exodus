extends Resource
class_name Tool

@export var name := ""
@export var icon: Texture2D
@export var max_val := 999
@export var is_good := true	# false to swap red/green color in toolbar

static var name_regex: RegEx = RegEx.new()

static func _static_init() -> void:
	name_regex.compile("^[a-z_]+$", true)
	time = make("time", 9999, false)

@warning_ignore("shadowed_variable")
static func make(
	name: String, max_val: int = 999, is_good: bool = true,
	icon: Texture2D = null
) -> Tool:
	var tool := new()
	
	if name_regex.search(name).get_string(0) != name:
		# invalid name
		return null
	tool.name = name
	
	tool.max_val = max_val
	tool.is_good = is_good
	
	if icon == null:
		var path := "res://assets/tools/{0}.png".format([name])
		if FileAccess.file_exists(path):
			icon = load(path)
		else:
			path = "user://assets/tools/{0}.png".format([name])
			if not FileAccess.file_exists(path):
				print("Couldn't find an icon matching the tool name.")
				return null
			icon = ImageTexture.create_from_image(Image.load_from_file(path))
	tool.icon = icon
	
	return tool

# vanilla tools

static var time: Tool
