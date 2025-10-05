extends RefCounted
class_name DexEntryData

var entry_number := 0
var shape: Global.Shapes
var colour: Global.Colours
var rarity: Global.Rarities
var entry_name: String
var acquired := false


func init_vars(in_shape, in_colour, in_rarity, in_name, in_number):
	shape = in_shape
	colour = in_colour
	rarity = in_rarity
	entry_name = in_name
	entry_number = in_number