extends Resource
class_name MookStats

enum Shapes {
	POINTY,
	BLOCKY,
	CHUBBY,
	STUBBY
}

enum Colours {
	RED,
	GREEN,
	BLUE,
	CYAN,
	MAGENTA,
	YELLOW
}

enum Rarity {
	COMMON,
	RARE1,
	RARE2
}

var shape: Shapes

var colour: Colours

var rarity: Rarity

var name: String


func is_common() -> bool:
	return rarity <= Rarity.COMMON
