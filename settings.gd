extends Node

enum {LOAD_SUCCESS, LOAD_ERROR_COULDNT_OPEN}
const SAVE_PATH = "user://settings.cfg"
var settings_file = ConfigFile.new()
var settings_dict = {
	"Sound":{
		"Master" : 100,
		"Ambient": 100,
		"Dialogue": 100,
		"Music": 100
		},
	"Controls":{
		"a" : 1
		},
	"Graphics":{
		"WindowMode" : "Fullscreen",
		"DisplayMonitor" : 0
		},
	"General":{
		"a" : 1,
		"b" : 3
		}
	}

func save_settings():
	for section in settings_dict.keys():
		for key in settings_dict[section].keys():
			settings_file.set_value(section, key, settings_dict[section][key])
	
	settings_file.save(SAVE_PATH)

func load_settings():
	var error = settings_file.load(SAVE_PATH)
	if error != OK:
		print("Error loading the settings. Error code: %s" % error)
		return LOAD_ERROR_COULDNT_OPEN
	
	for section in settings_dict.keys():
		for key in settings_dict[section].keys():
			
			var value = settings_file.get_value(section, key)
			settings_dict[section][key] = value
			
			#settings_dict[section][key] = settings_file.get_value(section, key) 
			#print("%s: %s: %s" % [section, key, value]) # Delete during clean up

func check_for_file():
	var dir = Directory.new()
	var settings_dict = {}
	if dir.file_exists(SAVE_PATH):
		#continue
		load_settings()
	else:
		#create file with default settings
		save_settings()

func set_settings():
	load_settings()
	
	#General settings
	match settings_dict["Graphics"]["WindowMode"]:
		"Fullscreen":
			OS.window_fullscreen = true
		"Windowed":
			OS.window_maximized = true
		"Borderless":
			OS.window_borderless = true
	
	OS.current_screen = settings_dict["Graphics"]["DisplayMonitor"]
	#Graphic settings
	
	#Sound settings
	
	#Control settings
	
