extends Control

func _on_new_game_button_pressed():
	$animation_player.play("new_game")

func _on_load_game_button_pressed():
	$animation_player.play("load_game")

func _on_settings_button_pressed():
	$animation_player.play("settings")

func _on_quit_button_pressed():
	get_tree().quit()

#NEW GAME


#LOAD GAME
var save_game_list = []
var save_file_to_delete

func load_player_save_cards():
	save_game_list = []
	


#SETTINGS
