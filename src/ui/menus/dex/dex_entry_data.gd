extends RefCounted
class_name DexEntryData

var shape : Global.Shapes
var colour : Global.Colours
var rarity : Global.Rarities
var entry_name : String
var acquired := false


func init_vars(in_shape, in_colour, in_rarity, in_name):
	shape = in_shape
	colour = in_colour
	rarity = in_rarity
	entry_name = in_name