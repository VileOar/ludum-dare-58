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

# if changed then also change material list
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

var sprite_frames = {
	Shapes.POINTY: preload("uid://dntarescsau6g"),
	Shapes.BLOCKY: preload("uid://2sswebanku4p"),
	Shapes.CHUBBY: preload("uid://d0rf6l76dby5"),
	Shapes.STUBBY: preload("uid://cxebhbvprf5m6"),
}

var Materials = [
	preload("res://assets/shaders/red_material.tres"),		# RED = 0
	preload("res://assets/shaders/orange_material.tres"),	# ORANGE = 1
	preload("res://assets/shaders/yellow_material.tres"),	# YELLOW = 2
	preload("res://assets/shaders/green_material.tres"),	# GREEN = 3
	preload("res://assets/shaders/blue_material.tres"),		# BLUE = 4
	preload("res://assets/shaders/purple_material.tres")	# PURPLE = 5
]


var shape_tiles = {
	Shapes.POINTY: preload("uid://bjgvaehjx2h3k"),
	Shapes.BLOCKY: preload("uid://dj7t4je2haurw"),
	Shapes.CHUBBY: preload("uid://bem0nxku82aiv"),
	Shapes.STUBBY: preload("uid://4q8q3wrsvo5x")
}

var colour_codes = {
	Colours.RED: [1.0, 0.0, 0.3],
	Colours.ORANGE: [1.0, 0.6, 0.0],
	Colours.YELLOW: [1.0, 0.9, 0.1],
	Colours.GREEN: [0.0, 0.9, 0.2],
	Colours.BLUE: [0.1, 0.6, 1.0],
	Colours.PURPLE: [1.0, 0.4, 0.6]
}

var rarity_icons = {
	Rarities.COMMON: preload("uid://dy6d5usgyxd5a"),
	Rarities.RARE: preload("uid://dsq5ari0w0eeo"),
	Rarities.LEGENDARY: preload("uid://bikykts0p4a6x")
}
