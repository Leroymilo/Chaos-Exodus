extends PanelContainer

signal confirm(text: String)
signal cancel

@export var title: String = "Text Dialog"

func _ready():
	$VBoxContainer/Label.text = title
	visible = false

func start():
	visible = true
	$VBoxContainer/TextEdit.text = ""
	$VBoxContainer/ErrorMsg.text = ""

func end():
	visible = false

func set_error(text: String):
	$VBoxContainer/ErrorMsg.text = ""

func on_cancel():
	cancel.emit()

func on_confirm():
	confirm.emit($VBoxContainer/TextEdit.text)
