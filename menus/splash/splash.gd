extends Node

func _ready():
	#Sets the game settings from the config file
	settings.check_for_file()


func _input(event):
	if event.is_action("ui_left_select"):
		$animation_player.stop()
		loading_screen.goto_scene("res://")
