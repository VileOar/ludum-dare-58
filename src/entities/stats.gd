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
	var random_no: float = randf()
	if random_no < (1 - (Global.RARE_MOOK_CHANCE + Global.LEGENDARY_MOOK_CHANCE)):
		stats.rarity = Global.Rarities.COMMON
	elif random_no < (1 - Global.LEGENDARY_MOOK_CHANCE):
		stats.rarity = Global.Rarities.RARE
	else:
		stats.rarity = Global.Rarities.LEGENDARY
	
	# TODO: choose name according to rarity
	return stats


func is_common() -> bool:
	return rarity <= Global.Rarities.COMMON
