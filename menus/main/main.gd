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
	
	check_for_files()

#Checks the user path to find all the save files stored in the folder, it will then create an array for that file's name and date of last save to then be stored in the array SaveGameList
func check_for_files():
	var path = "user://save_games/"
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var i = 0
		while (file_name != ""):
			if dir.current_is_dir():
				pass
			else:
				i = i+1
				#Function for adding nodes with file_name as arg
				_create_save_game_list(i,file_name)
			file_name = dir.get_next() 
	else:
		print("An error occurred when trying to access the path.")

#SETTINGS
