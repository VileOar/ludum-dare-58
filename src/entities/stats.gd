extends Resource
class_name MookStats

var shape: Global.Shapes

var colour: Global.Colours

var rarity: Global.Rarities

var name: String


static func build_random_stats() -> MookStats:
	var stats = MookStats.new()
	# TODO: give random values according to probabilities
	return stats


func is_common() -> bool:
	return rarity <= Global.Rarities.COMMON
