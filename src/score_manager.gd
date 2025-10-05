extends Node2D

var _same_colour_streak: int = 1
var _same_shape_streak: int = 1

var _unique_shape_same_colour_streak: int = 1
var _same_shape_unique_colour_streak: int = 1

var _3_shapes_of_colour_counter: int = 0
var _all_shapes_of_colour_counter: int = 0
var _all_colours_of_shape_counter: int = 0

var _unique_shapes: Array
var _unique_shapes_remaining: Array

var _unique_colours: Array
var _unique_colours_remaining: Array

var _last_collected_mook: MookStats
var _second_to_last_collected_mook: MookStats

func _ready() -> void:
	# initialize unique shapes arrays
	_unique_shapes = Global.Shapes.values()
	_reset_unique_shapes_remaining()
	# initialize unique colours arrays
	_unique_colours = Global.Colours.values()
	_reset_unique_colours_remaining()

func _reset_unique_shapes_remaining() -> void:
	_unique_shapes_remaining = Global.Shapes.values()

func _reset_unique_colours_remaining() -> void:
	_unique_colours_remaining = Global.Colours.values()

func _on_collect(collected_mook : Mook) -> void:
	_second_to_last_collected_mook = _last_collected_mook
	_last_collected_mook = collected_mook.get_stats()
	
	if(!_second_to_last_collected_mook):
		return
	# the updates and checks below have to be done in this order
	_update_same_colour_streak()
	_update_unique_shape_same_colour_streak()
	_3_shapes_of_colour_check()
	_all_shapes_of_colours_check()
	
	_update_same_shape_streak()
	_update_same_shape_unique_colour_streak()
	_all_colours_of_shape_check()

func _update_same_colour_streak() -> void:
	if(_last_collected_mook.colour == _second_to_last_collected_mook.colour):
		# continue the streak
		_same_colour_streak += 1
	else:
		# reset the streak
		_same_colour_streak = 1

func _update_same_shape_streak() -> void:
	if(_last_collected_mook.shape == _second_to_last_collected_mook.shape):
		# continue the streak
		_same_shape_streak += 1
	else:
		# reset the streak
		_same_shape_streak = 1

func _update_unique_shape_same_colour_streak() -> void:
	if(_same_colour_streak == 1):
		_reset_unique_shape_same_colour_streak()
		return
	if(_last_collected_mook.shape == _second_to_last_collected_mook.shape):
		_reset_unique_shape_same_colour_streak()
		return
	if(_unique_shapes_remaining.has(_last_collected_mook.shape)):
		_unique_shapes_remaining.erase(_last_collected_mook.shape)
		_unique_shapes_remaining.erase(_second_to_last_collected_mook.shape)
		_unique_shape_same_colour_streak += 1
	else:
		_reset_unique_shape_same_colour_streak()

func _reset_unique_shape_same_colour_streak() -> void:
	_unique_shape_same_colour_streak = 1
	_reset_unique_shapes_remaining()

func _update_same_shape_unique_colour_streak() -> void:
	if(_same_shape_streak == 1):
		_reset_same_shape_unique_colour_streak()
		return
	if(_last_collected_mook.colour == _second_to_last_collected_mook.colour):
		_reset_same_shape_unique_colour_streak()
		return
	if(_unique_colours_remaining.is_empty()):
		_reset_same_shape_unique_colour_streak()
		return
	if(	_unique_colours_remaining.has(_last_collected_mook.colour)):
		_unique_colours_remaining.erase(_last_collected_mook.colour)
		_unique_colours_remaining.erase(_second_to_last_collected_mook.colour)
		_same_shape_unique_colour_streak += 1
	else:
		_reset_same_shape_unique_colour_streak()

func _reset_same_shape_unique_colour_streak() -> void:
	_same_shape_unique_colour_streak = 1
	_reset_unique_colours_remaining()

# checks if last 3 collected mooks are of the same colour and different shapes
func _3_shapes_of_colour_check() -> void:
	if(_unique_shape_same_colour_streak == 3):
		_3_shapes_of_colour_counter += 1

# checks if last 4 collected mooks are of the same colour and different shapes
func _all_shapes_of_colours_check() -> void:
	if(_unique_shape_same_colour_streak == _unique_shapes.size()):
		_all_shapes_of_colour_counter += 1
		_3_shapes_of_colour_counter -= 1

# checks if last 6 collected mooks are of the same shape and different colours
func _all_colours_of_shape_check() -> void:
	if(_same_shape_unique_colour_streak == _unique_colours.size()):
		_all_colours_of_shape_counter += 1
