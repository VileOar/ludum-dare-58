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

# DEBUG ONLY
var mooks_to_collect: Array[MookStats]
############

func _ready() -> void:
	# initialize unique shapes arrays
	_unique_shapes = Global.Shapes.values()
	_reset_unique_shapes_remaining()
	# initialize unique colours arrays
	_unique_colours = Global.Colours.values()
	_reset_unique_colours_remaining()
	# DEBUG ONLY
	for i in 7:
		mooks_to_collect.append(MookStats.new())
	mooks_to_collect[0].colour = Global.Colours.RED
	mooks_to_collect[0].shape = Global.Shapes.POINTY
	mooks_to_collect[1].colour = Global.Colours.RED
	mooks_to_collect[1].shape = Global.Shapes.BLOCKY
	mooks_to_collect[2].colour = Global.Colours.RED
	mooks_to_collect[2].shape = Global.Shapes.CHUBBY
	mooks_to_collect[3].colour = Global.Colours.RED
	mooks_to_collect[3].shape = Global.Shapes.STUBBY
	mooks_to_collect[4].colour = Global.Colours.RED
	mooks_to_collect[4].shape = Global.Shapes.POINTY
	mooks_to_collect[5].colour = Global.Colours.RED
	mooks_to_collect[5].shape = Global.Shapes.POINTY
	mooks_to_collect[6].colour = Global.Colours.RED
	mooks_to_collect[6].shape = Global.Shapes.POINTY
	for mook in mooks_to_collect:
		_on_collect(mook)
	############

func _reset_unique_shapes_remaining() -> void:
	_unique_shapes_remaining = Global.Shapes.values()

func _reset_unique_colours_remaining() -> void:
	_unique_colours_remaining = Global.Colours.values()

# TODO: revert back to mook instead of mookstats
func _on_collect(collected_mook : MookStats) -> void:
	_second_to_last_collected_mook = _last_collected_mook
	_last_collected_mook = collected_mook#.get_stats()
	
	if(!_second_to_last_collected_mook):
		return
	# the updates and checks below have to be done in this order
	_update_same_colour_streak()
	print("Same colour streak:" + str(_same_colour_streak))
	_update_unique_shape_same_colour_streak()
	print("uShape sColour streak:" + str(_unique_shape_same_colour_streak))
	_3_shapes_of_colour_check()
	_all_shapes_of_colours_check()
	
	_update_same_shape_streak()
	print("Same shape streak:" + str(_same_shape_streak))
	_update_same_shape_unique_colour_streak()
	print("sShape uColour streak:" + str(_same_shape_unique_colour_streak))
	_all_colours_of_shape_check()
	print("----------------------")

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
		# DEBUG ONLY
		print(">>> 3 shapes of same colour")

# checks if last 4 collected mooks are of the same colour and different shapes
func _all_shapes_of_colours_check() -> void:
	if(_unique_shape_same_colour_streak == _unique_shapes.size()):
		_all_shapes_of_colour_counter += 1
		_3_shapes_of_colour_counter -= 1
		print(">>> all shapes of same colour")

# checks if last 6 collected mooks are of the same shape and different colours
func _all_colours_of_shape_check() -> void:
	if(_same_shape_unique_colour_streak == _unique_colours.size()):
		_all_colours_of_shape_counter += 1
		print(">>> all colours of same shape")
