extends Node

var json_path = "res://assets/data/names_data.json"
var dex_entries = {}

var acquired_souls := 0
var roaming_souls := 0


func _ready():
	var item_dict = load_name_data()

	# Create dex_entries
	for shape in item_dict.keys():
		dex_entries.set(Global.Shapes[shape], {})
		for colour in item_dict[shape].keys():
			dex_entries[Global.Shapes[shape]].set(Global.Colours[colour], {})
			for rarity in item_dict[shape][colour].keys():
				dex_entries[Global.Shapes[shape]][Global.Colours[colour]].set(Global.Rarities[rarity], [])
				for single_name in item_dict[shape][colour][rarity]:
					var entry: DexEntryData = DexEntryData.new()
					entry.init_vars(Global.Shapes[shape], Global.Colours[colour], Global.Rarities[rarity], single_name, counter)

					counter += 1

					dex_entries[Global.Shapes[shape]][Global.Colours[colour]][Global.Rarities[rarity]].append(entry)


func load_name_data():
	if FileAccess.file_exists(json_path):
		var data_file = FileAccess.open(json_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())

		if parsed_result is Dictionary:
			return parsed_result
