extends Node

signal confirm(text: String)
signal cancel

@export var title: String = "Choice Dialog"

@onready var choice: OptionButton = $Panel/VBoxContainer/OptionButton

func _ready():
	$Panel/VBoxContainer/Label.text = title
	$Panel.visible = false

func start(options: Array[String]):
	$Panel.visible = true
	choice.clear()
	for option in options:
		choice.add_item(option)

func end():
	$Panel.visible = false

func on_cancel():
	cancel.emit()

func on_confirm():
	confirm.emit(choice.get_item_text(choice.selected))
