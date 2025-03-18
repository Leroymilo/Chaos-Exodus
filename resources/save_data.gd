extends Resource
class_name SaveData

@export_storage var scenario_id: String = "Demo"
@export_storage var region_id: String = "start"

@export_storage var position: Vector2i = Vector2i(2, 2)
@export_storage var tools: Dictionary[Globals.Tool, int] = {}

@export_storage var event_choices: Dictionary[String, PackedStringArray] = {}
# event_id -> [ branch_id ]
