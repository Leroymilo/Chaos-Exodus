extends Node

signal confirm(text: String)
signal cancel

@export var title: String = "Text Dialog"

func _ready():
	$Panel/VBoxContainer/Label.text = title
	$Panel.visible = false

func start():
	$Panel.visible = true
	$Panel/VBoxContainer/TextEdit.text = ""

func end():
	$Panel.visible = false

func on_cancel():
	cancel.emit()

func on_confirm():
	confirm.emit($Panel/VBoxContainer/TextEdit.text)
