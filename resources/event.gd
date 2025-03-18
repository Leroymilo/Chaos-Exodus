extends Resource
class_name Event

@export var id: String

@export var hidden := false
@export var conditions : Dictionary[String, PackedStringArray] = {}
# event_id -> [ branch_id ]

@export var script_path: String
@export var branches: Dictionary[String, String] = {}
# branch_id -> script_path
