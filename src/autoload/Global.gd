extends Node


# basic unit of measure
const BLOCK := 64.0

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
