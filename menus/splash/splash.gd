extends Node

func _ready():
	open_main_menu()

func _input(event):
	if event.is_action("ui_left_select"):
		$animation_player.stop()
		open_main_menu()

func open_main_menu():
	loading_screen.goto_scene("res://")
