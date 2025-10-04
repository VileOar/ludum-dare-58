extends Node

var json_path = "res:://assets/data/names_data.json"
var dex_entries = {}


func _ready():
	pass
	#var item_dict = load_name_data()

	#for shape in item_dict.keys():
	#    print(shape)


func load_name_data():
	if FileAccess.file_exists(json_path):
		var data_file = FileAccess.open(json_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())

		if parsed_result is Dictionary:
			return parsed_result
