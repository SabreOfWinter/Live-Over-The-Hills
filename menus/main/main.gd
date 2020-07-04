extends Control

const PATH = "user://save_games/"
const LOAD_GAME_CARD_CONTAINER_PATH = "load_game/nine_patch_rect/scroll_container/vbox_container"

func _ready():
	load_player_save_cards()

func _on_new_game_button_pressed():
	$animation_player.play("new_game")

func _on_load_game_button_pressed():
	$animation_player.play("load_game")

func _on_settings_button_pressed():
	$animation_player.play("settings")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_back_button_pressed():
	#Changes depending on the menu open
	if $new_game.visible == true || $load_game.visible == true || ($settings.visible == true && $settings/centerContainer/buttonsContainer.visible == true):
		$animation_player.play("back_to_menu")
	elif $settings.visible == true && $settings/centerContainer/buttonsContainer.visible == false && $settings/centerContainer/ninePatchRect.visible == true:
		$animation_player.play("settings_back")

#NEW GAME--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


#LOAD GAME-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
var save_game_list = []
var save_file_to_delete

func load_player_save_cards():
	save_game_list = []
	
	check_for_files()
	sort_file_list()
	create_save_game_cards()
	
	if save_game_list.size() == 0:
		$main/HBoxContainer/load_game_button.disabled = true

#Checks the user path to find all the save files stored in the folder, it will then create an array for that file's name and date of last save to then be stored in the array SaveGameList
func check_for_files():
	var dir = Directory.new()
	
	#Create directory if it doesn't exist
	if !dir.dir_exists(PATH):
		dir.make_dir(PATH)
	
	#Open directory
	if dir.open(PATH) == OK:
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
func create_save_game_list(i, file_name):
	#Opens and records the dictionary for the found file.
	var file = File.new()
	var file_path = str(PATH, file_name)
	var file_dict = {}
	
	file.open(file_path, file.READ)
	
	file_dict = parse_json(file.get_line())
	
	#Adds the current file's name and last saved date to an array that is then added to the savegame list array
	var year = file_dict["DateOfLastSave"]["year"]
	var month = file_dict["DateOfLastSave"]["month"]
	var day = file_dict["DateOfLastSave"]["day"]
	var hour = file_dict["DateOfLastSave"]["hour"]
	var minute = file_dict["DateOfLastSave"]["minute"]
	var second = file_dict["DateOfLastSave"]["second"]
	var current_file_name_and_date = []
	
	current_file_name_and_date = [file_name, year, month, day, hour, minute, second] #Player Sprite and gold
	save_game_list.append(current_file_name_and_date)

func create_save_game_cards():
	var file_dict = {}
	
	for current_save_game in save_game_list.size():
		var file = File.new()
		var file_path = str(PATH, save_game_list[current_save_game][0])
		var file_content = {}
		
		file.open(file_path, file.READ)
		file_content = parse_json(file.get_line())
		
		#Create each game card item in this for loop
		var save_file_container = MarginContainer.new()
		var inside_container = HBoxContainer.new()
		var player_model = TextureRect.new() #Change to the player model
		var information_container = VBoxContainer.new()
		var player_name_label = Label.new()
		var player_last_date_label = Label.new()
		var player_money_label = Label.new()
		var delete_button = Button.new()
		
		#Adds the nodes to create each player card
		get_node(LOAD_GAME_CARD_CONTAINER_PATH).add_child(save_file_container)
		get_node(get_path_to(save_file_container)).add_child(inside_container)
		get_node(get_path_to(inside_container)).add_child(player_model)
		get_node(get_path_to(inside_container)).add_child(information_container)
		get_node(get_path_to(inside_container)).add_child(delete_button)
		get_node(get_path_to(information_container)).add_child(player_name_label)
		get_node(get_path_to(information_container)).add_child(player_last_date_label)
		get_node(get_path_to(information_container)).add_child(player_money_label)
		
		#Clean file path to file name
		file_path.erase(file_path.length()-4,4)
		file_path.erase(0, 18)
		
		#Setting the elements of each player save file 
		save_file_container.name = file_path
		save_file_container.margin_left = 100
		save_file_container.margin_right = 100
		save_file_container.margin_bottom = 100
		save_file_container.margin_top = 100
		save_file_container.size_flags_horizontal = SIZE_EXPAND_FILL
		
		
		inside_container.connect("mouse_entered", self, "player_save_card_mouse_entered", [save_file_container.name])
		inside_container.connect("mouse_exited", self, "player_save_card_mouse_exited")
		inside_container.connect("gui_input", self, "player_save_card_pressed", [file_path])#Mouse press
		
		player_model.connect("mouse_entered", self, "player_save_card_mouse_entered", [save_file_container.name])
		player_model.connect("mouse_exited", self, "player_save_card_mouse_exited")
		#Mouse press
		
		information_container.connect("mouse_entered", self, "player_save_card_mouse_entered", [save_file_container.name])
		information_container.connect("mouse_exited", self, "player_save_card_mouse_exited")
		#Mouse press
		
		player_model.texture = load("res://playerIcon.png")
		#Set player model clothing, skin, hair
		
		information_container.size_flags_vertical = 3
		information_container.size_flags_horizontal = 3
		
		player_name_label.text = file_content["Name"]
		player_last_date_label.text = str(file_content["DateOfLastSave"]["day"], "/", file_content["DateOfLastSave"]["month"], "/", file_content["DateOfLastSave"]["year"])#str(SaveGameList[CurrentSaveGame][0])
		player_money_label.text = str(file_content["Money"], "Symbol")
		
		delete_button.text = "X"
		delete_button.size_flags_vertical = 0
		delete_button.connect("pressed", self, "delete_button_pressed", [file_path])
		
		for node in get_node(get_path_to(inside_container)).get_children():
			node.show_behind_parent = true

func player_save_card_mouse_entered(container_name):
	container_name.erase(0,14)
	if $ConfirmationDialog.visible == false:
		for i in get_node(LOAD_GAME_CARD_CONTAINER_PATH).get_children():
			var node_name = i.name
			node_name.erase(0,14)
			if node_name == container_name:
				i.modulate = Color(1.5, 1.5, 1.5)

func player_save_card_mouse_exited():
#	self_modulate = Color(1, 1, 1)
	for i in get_node(LOAD_GAME_CARD_CONTAINER_PATH).get_children():
		i.modulate = Color(1, 1, 1)

func player_save_card_pressed(ev, save_file_path):
	if ev.is_action_pressed("ui_left_select") and $ConfirmationDialog.visible == false:
		pass
		#LOAD GAME
		#global.SelectedSaveFilePath = SaveFilePath
		#LoadingScreen.goto_scene("res://scenes/game/GameWorld.tscn")

func delete_button_pressed(save_file_path_to_delete):
	save_file_to_delete = save_file_path_to_delete
	$ConfirmationDialog.show()
	$ConfirmationDialog.window_title = "Delete file!"
	$ConfirmationDialog.dialog_text = str("Are you sure you wish to delete: \n", save_file_path_to_delete, "?")
	$ConfirmationDialog.connect("confirmed", self, "delete_file")

func delete_file():
	$ConfirmationDialog.disconnect("confirmed", self, "delete_file")
	var dir = Directory.new()
	$load_game/nine_patch_rect/scroll_container/vbox_container.get_node(save_file_to_delete).free() #Deletes save game card of file
	dir.remove(str("user://save_games/", save_file_to_delete, ".dat")) #Deletes file in folder

#SETTINGS--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
const Settings_script = preload("res://settings.gd")
var settings_instance = Settings_script.new()
var settings = {}

func _on_generalButton_pressed():
	print('general')
	settings_instance.load_settings()
	print(settings_instance.settings_dict['General'])
	$animation_player.play("open_general")

func _on_graphicsButton_pressed():
	print('graphics')
	settings_instance.load_settings()
	print(settings_instance.settings_dict['Graphics'])
	$animation_player.play("open_graphics")
	#DisplayMonitor
	#WindowMode
	

func _on_soundButton_pressed():
	print('sound')
	settings_instance.load_settings()
	print(settings_instance.settings_dict['Sound'])
	$animation_player.play("open_sound")
	#Ambient
	#Dialogue
	#Master
	#Music

func _on_controlsButton_pressed():
	print('controls')
	settings_instance.load_settings()
	print(settings_instance.settings_dict['Controls'])

	$animation_player.play("open_controls")
