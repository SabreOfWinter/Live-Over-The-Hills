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
