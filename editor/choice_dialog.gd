extends PanelContainer

signal confirm(text: String)
signal cancel

@export var title: String = "Choice Dialog"

@onready var choice: OptionButton = $VBoxContainer/OptionButton

func _ready():
	$VBoxContainer/Label.text = title
	visible = false

func start(options: Array[String]):
	visible = true
	choice.clear()
	for option in options:
		choice.add_item(option)
	$VBoxContainer/ErrorMsg.text = ""

func end():
	visible = false

func set_error(text: String):
	$VBoxContainer/ErrorMsg.text = ""

func on_cancel():
	cancel.emit()

func on_confirm():
	confirm.emit(choice.get_item_text(choice.selected))
