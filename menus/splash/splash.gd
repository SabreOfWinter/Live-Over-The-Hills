extends Node

const main_menu_path = "res://"

func _ready():
	open_main_menu()

func _input(event):
	if event.is_action("ui_left_select"):
		$animation_player.stop()
		open_main_menu()

func open_main_menu():
	get_tree().change_scene(main_menu_path)
