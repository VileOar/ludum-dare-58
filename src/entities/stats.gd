extends Resource
class_name MookStats

var shape: Global.Shapes

var colour: Global.Colours

var rarity: Global.Rarities

var name: String


static func build_random_stats() -> MookStats:
	var stats = MookStats.new()
	stats.shape = Global.Shapes.values()[randi() % Global.Shapes.size()]
	stats.colour = Global.Colours.values()[randi() % Global.Colours.size()]
	# TODO: choose rarity according to actual probabilities
	stats.rarity = Global.Rarities.COMMON if randf() < 0.9 else Global.Rarities.RARE
	# TODO: choose name according to rarity
	return stats


func is_common() -> bool:
	return rarity <= Global.Rarities.COMMON
