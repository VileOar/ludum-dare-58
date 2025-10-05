extends PanelContainer

@onready var inner_background: PanelContainer = %InnerContainer
@onready var rarity_texture: TextureRect = %RarityTexture
@onready var name_label: Label = %NameLabel
@onready var checkbox_texture: TextureRect = %CheckboxTexture

var checkbox_empty: Texture = preload("uid://cruaeh6rxnbg3")
var checkbox_filled: Texture = preload("uid://bvam6cu1o8dp8")


func populate_entry(data: DexEntryData):

	var style_box_texture = StyleBoxTexture.new()
	style_box_texture.texture = Global.shape_tiles[data.shape]
	style_box_texture.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
	style_box_texture.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
	add_theme_stylebox_override("panel", style_box_texture)

	var style_box = StyleBoxFlat.new()
	var colour_code_array = Global.colour_codes[data.colour]
	style_box.bg_color = Color(colour_code_array[0], colour_code_array[1], colour_code_array[2])
	inner_background.add_theme_stylebox_override("panel", style_box)

	rarity_texture.texture = Global.rarity_icons[data.rarity]
	name_label.text = data.entry_name
	
	if data.acquired:
		checkbox_texture.texture = checkbox_filled
	else:
		checkbox_texture.texture = checkbox_empty
