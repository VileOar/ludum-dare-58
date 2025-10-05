extends ScrollContainer

@export var entry_scene: PackedScene

@onready var list: VBoxContainer = %List


func populate_list():
	for shape in DexManager.dex_entries.values():
		for colour in shape.values():
			for rarity in colour.values():
				for entry in rarity:
					create_entry(entry)


func create_entry(data: DexEntryData):	
	var dex_entry = entry_scene.instantiate()
	list.add_child(dex_entry)
	dex_entry.populate_entry(data)
