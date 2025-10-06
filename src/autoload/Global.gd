extends Node

# basic unit of measure
const BLOCK := 64.0

# number of spawned entities on start
const NUM_SPAWNED_MOOKS := 300

const RARE_MOOK_CHANCE: float = 0.05
const LEGENDARY_MOOK_CHANCE: float = 0.01

# base value of a collected soul
const BASE_SCORE: int = 10

# multipliers awarded on soul rarity
const RARE_MULTIPLIER: int = 2
const LEGENDARY_MULTIPLIER: int = 3
const RARE_SCORE: int = BASE_SCORE * RARE_MULTIPLIER
const LEGENDARY_SCORE: int = BASE_SCORE * LEGENDARY_MULTIPLIER

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

var _final_score: int = 0

var _sprite_frames: Dictionary[Shapes, SpriteFrames] = {
	Shapes.POINTY: preload("uid://dntarescsau6g"),
	Shapes.BLOCKY: preload("uid://2sswebanku4p"),
	Shapes.CHUBBY: preload("uid://d0rf6l76dby5"),
	Shapes.STUBBY: preload("uid://cxebhbvprf5m6"),
}

# filled with created materials in runtime (see ready())
var _materials: Dictionary[Colours, ShaderMaterial] = {}

# filled with created materials in runtime (see ready())
var _aura_materials: Dictionary[Rarities, ShaderMaterial] = {}

var colour_values = {
	Colours.RED: Color("ff004d"),
	Colours.ORANGE: Color("ffa300"),
	Colours.YELLOW: Color("ffec27"),
	Colours.GREEN: Color("00e436"),
	Colours.BLUE: Color("29adff"),
	Colours.PURPLE: Color("ff77a8"),
}

var rarity_colour_values = {
	Rarities.RARE: Color("e155ed"),
	Rarities.LEGENDARY: Color("f3ef7d")
}

var shape_icons = {
	Shapes.POINTY: preload("uid://bvdjwvlprjemr"),
	Shapes.BLOCKY: preload("uid://2nxfpkfatuoc"),
	Shapes.CHUBBY: preload("uid://cbqpmwtvv6i2l"),
	Shapes.STUBBY: preload("uid://btmruwtfctd0n")
}

var rarity_icons = {
	Rarities.COMMON: preload("uid://dy6d5usgyxd5a"),
	Rarities.RARE: preload("uid://dsq5ari0w0eeo"),
	Rarities.LEGENDARY: preload("uid://bikykts0p4a6x")
}


func _ready() -> void:
	for col in Colours.values():
		var mat = ShaderMaterial.new()
		mat.shader = preload("uid://h0ncu5q1xcr2")
		mat.set("shader_parameter/color", colour_values[col])
		_materials[col] = mat

	for rarity in rarity_colour_values.keys():
		var mat = ShaderMaterial.new()
		mat.shader = preload("uid://52oqfdc7rt6o")
		mat.set("shader_parameter/color", rarity_colour_values[rarity])

		mat.set("shader_parameter/n", preload("uid://chtyvf3fdmgx2"))
		mat.set("shader_parameter/intensity", 7)
		mat.set("shader_parameter/speed", 2.0)

		_aura_materials[rarity] = mat


func set_final_score(new_score) -> void:
	_final_score = new_score


func get_final_score() -> int:
	return _final_score


func get_spriteframes_from_shape(shape: Shapes) -> SpriteFrames:
	return _sprite_frames[shape]


func get_material_from_colour(colour: Colours) -> ShaderMaterial:
	return _materials[colour]


func get_all_materials() -> Array[ShaderMaterial]:
	return _materials.values()


func get_all_aura_materials() -> Array[ShaderMaterial]:
	return _aura_materials.values()
