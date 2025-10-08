extends Resource
class_name ComboRule

var _same_colour: bool = false
var _same_shape: bool = false
var _unique_colours: bool = false
var _unique_shapes: bool = false

var _combo_length: int
var _bonus_value: float
var _bonus_type: Global.BonusTypes

var _colour_sequence: Array[Global.Colours] = []
var _shape_sequence: Array[Global.Shapes] = []

var _allowed_colours: Array[Global.Colours] = []
var _allowed_shapes: Array[Global.Shapes] = []

#region Setters
func set_combo_length(req_length: int) -> void:
	_combo_length = req_length

func set_bonus(value: float, type: Global.BonusTypes) -> void:
	_bonus_value = value
	_bonus_type = type

## Makes the combo require all mooks to be of the same colour
func require_same_colour() -> void:
	_same_colour = true
## Makes the combo require all mooks to be of the same shape
func require_same_shape() -> void:
	_same_shape = true
## Makes the combo require all mooks to be of different colours
func require_unique_colours() -> void:
	_unique_colours = true
## Makes the combo require all mooks to be of different shapes
func require_unique_shapes() -> void:
	_unique_shapes = true
## Makes the combo require a specified sequence of colours
func require_colour_sequence(req_colour_sequence: Array[Global.Colours]) -> void:
	_colour_sequence = req_colour_sequence
## Makes the combo require a specified sequence of shapes
func require_shape_sequence(req_shape_sequence: Array[Global.Shapes]) -> void:
	_shape_sequence = req_shape_sequence
## Restricts the combo to a specific group of colours
func restrict_colours(allowed_colours: Array[Global.Colours]) -> void:
	_allowed_colours = allowed_colours
## Restricts the combo to a specific group of shapes
func restrict_shapes(allowed_shapes: Array[Global.Shapes]) -> void:
	_allowed_shapes = allowed_shapes
#endregion Setters

#region Getters
## Returns how many mooks are required to trigger the combo
func get_combo_length() -> int:
	return _combo_length

## Returns whether the combo requires all mooks to be of the same colour
func is_same_colour_req() -> bool:
	return _same_colour
## Returns whether the combo requires all mooks to be of the same shape
func is_same_shape_req() -> bool:
	return _same_shape
## Returns whether the combo requires all mooks to be of different colours
func is_unique_colours_req() -> bool:
	return _unique_colours
## Returns whether the combo requires all mooks to be of different shapes
func is_unique_shapes_req() -> bool:
	return _unique_shapes

## Returns whether the combo requires a specific sequence of colours
func is_colour_sequence_req() -> bool:
	return !_colour_sequence.is_empty()
## Returns whether the combo requires a specific sequence of shapes
func is_shape_sequence_req() -> bool:
	return !_shape_sequence.is_empty()
## Returns whether the combo requires a specific group of colours to be present
func is_colours_restricted() -> bool:
	return !_allowed_colours.is_empty()
## Returns whether the combo requires a specific group of shapes to be present
func is_shapes_restricted() -> bool:
	return !_allowed_shapes.is_empty()

## Gets the colour sequence required to score the combo
func get_colour_sequence() -> Array[Global.Colours]:
	return _colour_sequence
## Gets the shape sequence required to score the combo
func get_shape_sequence() -> Array[Global.Shapes]:
	return _shape_sequence
## Gets group of colours required to be present to score the combo
func get_allowed_colours() -> Array[Global.Colours]:
	return _allowed_colours
## Gets group of shapes required to be present to score the combo
func get_allowed_shapes() -> Array[Global.Shapes]:
	return _allowed_shapes

## Gets the value of the bonus to apply when the combo is scored
func get_bonus_value() -> float:
	return _bonus_value
## Gets the type of bonus to apply when the combo is scored
func get_bonus_type() -> Global.BonusTypes:
	return _bonus_type
#endregion Getters
