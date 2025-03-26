extends Control

var game: PackedScene 	= preload("res://scenes/game/game.tscn")
var scenario: Scenario 	= preload("res://scenarios/Demo/data.tres")

@onready var continue_butt := %Continue

func _ready() -> void:
	if FileAccess.file_exists("res://saves/demo_save.tres"):
		Globals.save_data = load("res://saves/demo_save.tres")
		continue_butt.disabled = false

func _on_start_pressed() -> void:
	
	Globals.save_data = SaveData.new()
	Globals.save_data.load_from_scenario(scenario)
	get_tree().change_scene_to_packed(game)

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_packed(game)

func _on_exit_pressed() -> void:
	get_tree().quit()
