extends Resource
class_name MookStats


var shape: Global.Shapes

var colour: Global.Colours

var rarity: Global.Rarities

var name: String


func is_common() -> bool:
	return rarity <= Global.Rarities.COMMON
