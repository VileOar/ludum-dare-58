extends PanelContainer

@onready var colour_backgrond: ColorRect = %ColourBackground
@onready var shape_texture: TextureRect = %ShapeTexture
@onready var rarity_texture: TextureRect = %RarityTexture
@onready var name_label: Label = %NameLabel
@onready var checkbox_texture: TextureRect = %CheckboxTexture

var checkbox_empty: Texture = preload("uid://cruaeh6rxnbg3")
var checkbox_filled: Texture = preload("uid://bvam6cu1o8dp8")

var data_copy: DexEntryData


func populate_entry(data: DexEntryData):
	data_copy = data

	colour_backgrond.color = Global.colour_values[data_copy.colour]
	shape_texture.texture = Global.shape_icons[data_copy.shape]
	rarity_texture.texture = Global.rarity_icons[data_copy.rarity]
	name_label.text = data_copy.entry_name
	
	if data_copy.acquired:
		checkbox_texture.texture = checkbox_filled
	else:
		checkbox_texture.texture = checkbox_empty
