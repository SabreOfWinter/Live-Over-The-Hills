extends Node

const MAIN_MENU_PATH = "res://menus/main/main.tscn"

func _ready():
	open_main_menu()

func _input(event):
	if event.is_action("ui_left_select"):
		$animation_player.stop()
		open_main_menu()

func open_main_menu():
	get_tree().change_scene(MAIN_MENU_PATH)
