extends Control

@onready var error_message = $VBoxContainer/Message

func on_tile_editor_error_message(msg):
	error_message.text = msg
