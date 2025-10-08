extends Node

# basic unit of measure
const BLOCK := 64.0

# maximum mooks that can be collected before the game ends
const MAX_BAG_SLOTS : int = 50
# time limit before the game ends (in seconds)
const TIME_LIMIT: int = 60

# number of spawned entities on start
const NUM_SPAWNED_MOOKS := 300

const RARE_MOOK_CHANCE: float = 0.05
const LEGENDARY_MOOK_CHANCE: float = 0.01

# base value of a collected soul
const BASE_SCORE: int = 10

const GOOD_SCORE_THRESHOLD: int = 650

# multipliers awarded on soul rarity
const _RARE_MULTIPLIER: int = 2
const _LEGENDARY_MULTIPLIER: int = 3
const RARE_SCORE: int = BASE_SCORE * _RARE_MULTIPLIER
const LEGENDARY_SCORE: int = BASE_SCORE * _LEGENDARY_MULTIPLIER

# all combos that exist and their respective scores
#region Combos
enum BonusTypes{
	FLAT,
	MULTIPLIER
}
# combos are in order of priority 
# (if conditions overlap, whichever one comes first is the one that applies)
enum Combos {
	FIVE_MOOKS_SAME_COLOUR,
	ALL_SHAPES_SAME_COLOUR,
	ALL_SHAPES_ANY_COLOUR,
	ALL_COLOURS_IN_ORDER_SAME_SHAPE,
	ALL_COLOURS_SAME_SHAPE,
	ALL_COLOURS_IN_ORDER_ANY_SHAPE,
	ALL_COLOURS_ANY_SHAPE,
	PORTUGAL_COLOURS_SAME_SHAPE,
	PORTUGAL_COLOURS_TTSSCC_SHAPES,
	PORTUGAL_COLOURS_ANY_SHAPE
}

# pairs each combo to their rules -> initialized on ready()
var combo_rules: Dictionary[int, ComboRule]
#endregion Combos

# mouse circle shader uniforms
const MOUSE_CIRCLE_RADIUS := 150.0
const MOUSE_CIRCLE_SMOOTH_WIDTH := 50.0

# filepaths to the game scenes
const TITLE_SCENE_FILEPATH: String = "res://src/stages/main_menu.tscn"
const LEVEL_SCENE_FILEPATH: String = "res://src/stages/level.tscn"
const SCORE_SCENE_FILEPATH: String = "res://src/stages/score_screen.tscn"

# end game messages
const END_MESSAGE_FULL_BAG: String = "Rest In Peace"
const END_MESSAGE_TIMEOUT: String = "Your Time Has Come"

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

# stores the final score achieved in the game
var _final_score: int = 0
# stores the message to display on the score screen
var _end_game_message: String = END_MESSAGE_FULL_BAG
# stores whether the game is currently paused
var _is_paused: bool = false

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
	
	#region Initialize combo rules
	# Populate combo rules array
	for c in Combos.values():
		combo_rules[c] = ComboRule.new()
	
	# Set rules for each combo
	# FIVE_MOOKS_SAME_COLOUR
	var current_rule  = combo_rules[Combos.FIVE_MOOKS_SAME_COLOUR]
	current_rule.set_combo_length(5)
	current_rule.set_bonus(2, BonusTypes.MULTIPLIER)
	current_rule.require_same_colour()
	
	# ALL_SHAPES_SAME_COLOUR
	current_rule  = combo_rules[Combos.ALL_SHAPES_SAME_COLOUR]
	current_rule.set_combo_length(Shapes.size())
	current_rule.set_bonus(3, BonusTypes.MULTIPLIER)
	current_rule.require_unique_shapes()
	current_rule.require_same_colour()
	
	# ALL_SHAPES_ANY_COLOUR
	current_rule = combo_rules[Combos.ALL_SHAPES_ANY_COLOUR]
	current_rule.set_combo_length(Shapes.size())
	current_rule.set_bonus(2, BonusTypes.MULTIPLIER)
	current_rule.require_unique_shapes()

	# ALL_COLOURS_IN_ORDER_SAME_SHAPE
	current_rule = combo_rules[Combos.ALL_COLOURS_IN_ORDER_SAME_SHAPE]
	current_rule.set_combo_length(Colours.size())
	current_rule.set_bonus(7, BonusTypes.MULTIPLIER)
	current_rule.require_same_shape()
	current_rule.require_colour_sequence(
		[Colours.RED, Colours.ORANGE, Colours.YELLOW, Colours.GREEN, Colours.BLUE, Colours.PURPLE]
		)
	
	# ALL_COLOURS_SAME_SHAPE
	current_rule = combo_rules[Combos.ALL_COLOURS_SAME_SHAPE]
	current_rule.set_combo_length(Colours.size())
	current_rule.set_bonus(3.5, BonusTypes.MULTIPLIER)
	current_rule.require_same_shape()
	current_rule.require_unique_colours()
	
	# ALL_COLOURS_IN_ORDER_ANY_SHAPE
	current_rule = combo_rules[Combos.ALL_COLOURS_IN_ORDER_ANY_SHAPE]
	current_rule.set_combo_length(Colours.size())
	current_rule.set_bonus(4, BonusTypes.MULTIPLIER)
	current_rule.require_colour_sequence(
		[Colours.RED, Colours.ORANGE, Colours.YELLOW, Colours.GREEN, Colours.BLUE, Colours.PURPLE]
		)
	
	# ALL_COLOURS_ANY_SHAPE
	current_rule = combo_rules[Combos.ALL_COLOURS_ANY_SHAPE]
	current_rule.set_combo_length(Colours.size())
	current_rule.set_bonus(2, BonusTypes.MULTIPLIER)
	current_rule.require_unique_colours()
	
	# PORTUGAL_COLOURS_SAME_SHAPE
	current_rule = combo_rules[Combos.PORTUGAL_COLOURS_SAME_SHAPE]
	current_rule.set_combo_length(6)
	current_rule.set_bonus(6.5, BonusTypes.MULTIPLIER)
	current_rule.require_same_shape()
	current_rule.require_colour_sequence(
		[Colours.GREEN, Colours.GREEN, Colours.YELLOW, Colours.RED, Colours.RED, Colours.RED]
		)
	
	# PORTUGAL_COLOURS_TTSSCC_SHAPES
	current_rule = combo_rules[Combos.PORTUGAL_COLOURS_TTSSCC_SHAPES]
	current_rule.set_combo_length(6)
	current_rule.set_bonus(5.5, BonusTypes.MULTIPLIER)
	current_rule.require_colour_sequence(
		[Colours.GREEN, Colours.GREEN, Colours.YELLOW, Colours.RED, Colours.RED, Colours.RED]
		)
	current_rule.require_shape_sequence(
		[Shapes.BLOCKY, Shapes.BLOCKY, Shapes.CHUBBY, Shapes.BLOCKY, Shapes.BLOCKY, Shapes.BLOCKY]
		)
	
	# PORTUGAL_COLOURS_ANY_SHAPE
	current_rule = combo_rules[Combos.PORTUGAL_COLOURS_ANY_SHAPE]
	current_rule.set_combo_length(6)
	current_rule.set_bonus(3.5, BonusTypes.MULTIPLIER)
	current_rule.require_colour_sequence(
		[Colours.GREEN, Colours.GREEN, Colours.YELLOW, Colours.RED, Colours.RED, Colours.RED]
		)
	#endregion Initialize combo rules


func get_spriteframes_from_shape(shape: Shapes) -> SpriteFrames:
	return _sprite_frames[shape]


func get_material_from_colour(colour: Colours) -> ShaderMaterial:
	return _materials[colour]


func get_all_materials() -> Array[ShaderMaterial]:
	return _materials.values()


func get_all_aura_materials() -> Array[ShaderMaterial]:
	return _aura_materials.values()

# getter and setter for _final_score
func set_final_score(new_score) ->  void:
	_final_score = new_score

func get_final_score() -> int:
	return _final_score

# getter and setter for _is_paused
func set_is_paused(new_value: bool) -> void:
	_is_paused = new_value

func get_is_paused() -> bool:
	return _is_paused

# getter and setter for _end_message
func set_end_message(new_msg: String) -> void:
	_end_game_message = new_msg

func get_end_message() -> String:
	return _end_game_message
