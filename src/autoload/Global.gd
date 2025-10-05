extends Node

# basic unit of measure
const BLOCK := 64.0

# base value of a collected soul
const BASE_SCORE : int = 10

# multipliers awarded on soul rarity
const RARE_MULTIPLIER: int = 2
const LEGENDARY_MULTIPLIER: int = 3

# bonus awarded on getting 3 shapes of the same colour in a row
const THREE_SHAPES_OF_COLOUR_BONUS: int = BASE_SCORE
# multiplier awarded on getting all shapes of the same colour in a row
const ALL_SHAPES_OF_COLOUR_MULTIPLIER: int = 2
# multiplier awarded on getting all colours of the same shape in a row
const ALL_COLOURS_OF_SHAPE_MULTIPLIER: int = 3

# mouse circle shader uniforms
const MOUSE_CIRCLE_RADIUS := 150.0
const MOUSE_CIRCLE_SMOOTH_WIDTH := 50.0

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
