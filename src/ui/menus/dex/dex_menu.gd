extends PanelContainer

@export var entry_scene: PackedScene

@onready var show_button: MenuButton = %ShowButton
@onready var acquired_label: Label = %AcquiredNumber
@onready var roaming_label: Label = %RoamingNumber
@onready var list: VBoxContainer = %List


func _ready():
	acquired_label.text = str(DexManager.acquired_souls)
	roaming_label.text = str(DexManager.roaming_souls)

	#TODO: Show flags not yet implemented
	#show_button.get_popup().id_pressed.connect(_hello_there)

	populate_list()


func refresh():
	#TODO: possibly needed in case data changes while dex menu is already instantiated
	pass


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


func clear_list():
	if list.get_child_count() == 0:
		return

	var children = list.get_children()
	for c in children:
		list.remove_child(c)
		c.queue_free()


# ---------------------
# || --- SORTS --- ||
# ---------------------

func standard_sort(a, b):
	if a.data_copy.entry_number > b.data_copy.entry_number:
		return true
	return false


func sort_by_colour(a, b):
	if a.data_copy.colour > b.data_copy.colour:
		return true
	if a.data_copy.colour == b.data_copy.colour:
		if a.data_copy.entry_number > b.data_copy.entry_number:
			return true
	return false


func sort_by_rarity(a, b):
	if a.data_copy.rarity > b.data_copy.rarity:
		return true
	if a.data_copy.rarity == b.data_copy.rarity:
		if a.data_copy.entry_number > b.data_copy.entry_number:
			return true
	return false


func sort_by_acquisition(a, b):
	if a.data_copy.acquired == true and b.data_copy.acquired == false:
		return true

	if a.data_copy.acquired == b.data_copy.acquired:
		if a.data_copy.entry_number > b.data_copy.entry_number:
			return true

	return false


# ---------------------
# || --- SIGNALS --- ||
# ---------------------

func _on_sort_button_item_selected(index):
	var children = list.get_children()

	match index:
		0:
			children.sort_custom(standard_sort)
		1:
			children.sort_custom(sort_by_colour)
		2:
			children.sort_custom(sort_by_rarity)
		3:
			children.sort_custom(sort_by_acquisition)

	for c in children:
		list.move_child(c, 0)


func _on_close_pressed() -> void:
	_play_click_sfx()
	self.visible = false

#region audio
func _play_click_sfx() -> void:
	AudioManager.play_click_sfx()
	
func _play_hover_sfx() -> void:
	AudioManager.play_hover_sfx()
	
func _on_button_mouse_entered():
	_play_hover_sfx()
#endregion
