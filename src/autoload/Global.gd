extends Node


# basic unit of measure
const BLOCK := 64.0

# base value of a collected soul
const BASE_SCORE : int = 10
# extra score awarded on soul rarity
const RARE_BONUS: int = 10
const LEGENDARY_BONUS: int = 20
enum Shapes {
	POINTY,
	BLOCKY,
	CHUBBY,
	STUBBY
}

enum Colours {
	RED,
	ORANGE,
	YELLOW,
	GREEN, 
	BLUE, 
	PURPLE 
}

enum Rarities {
	COMMON,
	RARE,
	LEGENDARY
}
