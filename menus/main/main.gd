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
	sort_file_list()

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
				create_save_game_list(i,file_name)
			file_name = dir.get_next() 
	else:
		print("An error occurred when trying to access the path.")

#Using the ListSorter class, this function will sort the arrays in the SaveGameList array with the newest dates going first and descending from there
func sort_file_list():
	save_game_list.sort_custom(ListSorter, "sortList")

#This class will compare the date of two files using the two arrays
class ListSorter:
	static func sortList(a,b):
		#year = [1], month  = [2], day  = [3], hour  = [4], minute = [5], second = [6]
		var CompareYear = a[1] > b[1]
		var CompareMonth = (a[1]==b[1] and a[2] > b[2])
		var CompareDay = (a[1]==b[1] and a[2]==b[2] and a[3] > b[3])
		var CompareHour = (a[1]==b[1] and a[2]==b[2] and a[3]==b[3] and a[4] > b[4])
		var CompareMinute = (a[1]==b[1] and a[2]==b[2] and a[3]==b[3] and a[4]==b[4] and a[5] > b[5])
		var CompareSecond = (a[1]==b[1] and a[2]==b[2] and a[3]==b[3] and a[4]==b[4] and a[5]==b[5] and a[6] > b[6])
		
		return CompareYear or CompareMonth or CompareDay or CompareHour or CompareMinute or CompareSecond

#Creates an array with the current filename and date of last save then adds that array into the SaveGameList array
func create_save_game_list(i,FileName):
	#Opens and records the dictionary for the found file.
	var file = File.new()
	var FilePath = str("user://save_games/", FileName)
	var file_dict = {}
	
	file.open(FilePath, file.READ)
	
	file_dict = parse_json(file.get_line())
	
	#Adds the current file's name and last saved date to an array that is then added to the savegame list array
	var year = file_dict["DateOfLastSave"]["year"]
	var month = file_dict["DateOfLastSave"]["month"]
	var day = file_dict["DateOfLastSave"]["day"]
	var hour = file_dict["DateOfLastSave"]["hour"]
	var minute = file_dict["DateOfLastSave"]["minute"]
	var second = file_dict["DateOfLastSave"]["second"]
	var current_file_name_and_date = []
	
	current_file_name_and_date = [FileName, year, month, day, hour, minute, second] #Player Sprite and gold
	save_game_list.append(current_file_name_and_date)

#SETTINGS
