extends Resource
class_name EventData

@export var id: String

@export var hidden := false
@export var condition: Condition = TrueCondition.new()

@export var script_path: String
@export var branch_paths: Dictionary[String, String] = {}
# branch_id -> script_path
