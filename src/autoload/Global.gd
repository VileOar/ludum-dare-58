extends Node


# basic unit of measure
const BLOCK := 64.0

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
