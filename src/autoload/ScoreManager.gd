extends Node2D

signal scored_a_combo(combo_score)

# store streak counts
var _same_colour_streak: int = 1
var _same_shape_streak: int = 1
var _unique_shape_same_colour_streak: int = 1
var _same_shape_unique_colour_streak: int = 1
# count how many mooks were collected (+by rarity)
var _collected_mooks_total: int = 0
var _collected_commons_counter: int = 0
var _collected_rares_counter: int = 0
var _collected_legendaries_counter: int = 0
# count how many times each combo was made
var _3_shapes_of_colour_counter: int = 0
var _all_shapes_of_colour_counter: int = 0
var _all_colours_of_shape_counter: int = 0
# store how many unique shapes/colours exist and which ones are left to make a combo
var _unique_shapes: Array
var _unique_shapes_remaining: Array
var _unique_colours: Array
var _unique_colours_remaining: Array
# array that stores all collected mooks
var _all_collected_mooks: Array[MookStats] = []
# store the stats of the last and second to last collected mook
var _last_collected_mook: MookStats
var _second_to_last_collected_mook: MookStats
# array that stores the last few collected mooks
var _last_collected_mooks: Array[MookStats] = []
# max amont of the last collected mooks that are kept stored
var _max_last_collected_mooks: int = 6
# stores the total score of all combos done
var _combo_score_total: int = 0
# stores the total score of mooks collected outside of combos
var _no_combo_score_total: int = 0

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

func on_collect(collected_mook : MookStats) -> void:
	_all_collected_mooks.push_back(collected_mook)
	_second_to_last_collected_mook = _last_collected_mook
	_last_collected_mook = collected_mook
	# add collected mook to array
	_update_last_collected_mooks(_last_collected_mook)
	
	# count collected mook
	_collected_mooks_total += 1
	# add score based on rarity
	match _last_collected_mook.rarity:
		Global.Rarities.COMMON:
			_collected_commons_counter += 1
			_no_combo_score_total += Global.BASE_SCORE
		Global.Rarities.RARE:
			_collected_rares_counter += 1
			_no_combo_score_total += Global.RARE_SCORE
		Global.Rarities.LEGENDARY:
			_collected_legendaries_counter += 1
			_no_combo_score_total += Global.LEGENDARY_SCORE
	
	# check for combos if more than 1 mook has been collected
	if !_second_to_last_collected_mook:
		return
	# first update the streak variables
	_update_same_colour_streaks()
	_update_same_shape_streaks()
	# then check if any of the combos apply
	_3_shapes_of_colour_check()
	_all_shapes_of_colours_check()
	_all_colours_of_shape_check()

# adds given mook to the collected mooks array and deletes the oldest if it is full
func _update_last_collected_mooks(collected_mook: MookStats):
	_last_collected_mooks.push_back(collected_mook)
	if _last_collected_mooks.size() > _max_last_collected_mooks:
		_last_collected_mooks.pop_front()

func _update_same_colour_streaks() -> void:
	if _last_collected_mook.colour == _second_to_last_collected_mook.colour:
		# continue the streak
		_same_colour_streak += 1
	else:
		# reset the streak
		_same_colour_streak = 1
	_update_unique_shape_same_colour_streak()

func _update_same_shape_streaks() -> void:
	if _last_collected_mook.shape == _second_to_last_collected_mook.shape:
		# continue the streak
		_same_shape_streak += 1
	else:
		# reset the streak
		_same_shape_streak = 1
	_update_same_shape_unique_colour_streak()

func _update_unique_shape_same_colour_streak() -> void:
	if _same_colour_streak == 1:
		_reset_unique_shape_same_colour_streak()
		return
	if _last_collected_mook.shape == _second_to_last_collected_mook.shape:
		_reset_unique_shape_same_colour_streak()
		return
	if _unique_shapes_remaining.has(_last_collected_mook.shape):
		_unique_shapes_remaining.erase(_last_collected_mook.shape)
		_unique_shape_same_colour_streak += 1
		if _unique_shape_same_colour_streak == 2:
			_unique_shapes_remaining.erase(_second_to_last_collected_mook.shape)
	else:
		_reset_unique_shape_same_colour_streak()

func _reset_unique_shape_same_colour_streak() -> void:
	_unique_shape_same_colour_streak = 1
	_reset_unique_shapes_remaining()

func _update_same_shape_unique_colour_streak() -> void:
	if _same_shape_streak == 1:
		_reset_same_shape_unique_colour_streak()
		return
	if _last_collected_mook.colour == _second_to_last_collected_mook.colour:
		_reset_same_shape_unique_colour_streak()
		return
	if _unique_colours_remaining.is_empty():
		_reset_same_shape_unique_colour_streak()
		return
	if _unique_colours_remaining.has(_last_collected_mook.colour):
		_unique_colours_remaining.erase(_last_collected_mook.colour)
		_same_shape_unique_colour_streak += 1
		if _same_shape_unique_colour_streak == 2:
			_unique_colours_remaining.erase(_second_to_last_collected_mook.colour)
	else:
		_reset_same_shape_unique_colour_streak()

func _reset_same_shape_unique_colour_streak() -> void:
	_same_shape_unique_colour_streak = 1
	_reset_unique_colours_remaining()

# checks if last 3 collected mooks are of the same colour and different shapes
func _3_shapes_of_colour_check() -> void:
	if _unique_shape_same_colour_streak == 3:
		_3_shapes_of_colour_counter += 1
		# calculate the combo score and add it to the total
		var combo_score = Global.THREE_SHAPES_OF_COLOUR_BONUS
		_combo_score_total += combo_score
		scored_a_combo.emit(combo_score)
		print(">>> 3 shapes of colours combo")

# checks if last 4 collected mooks are of the same colour and different shapes
func _all_shapes_of_colours_check() -> void:
	if _unique_shape_same_colour_streak == _unique_shapes.size():
		_all_shapes_of_colour_counter += 1
		# calculate the combo score and add it to the total
		var mook_score_total: int = _calculate_mook_score_in_combo(_unique_shapes.size())
		var combo_score = mook_score_total * Global.ALL_SHAPES_OF_COLOUR_MULTIPLIER
		_combo_score_total += combo_score
		scored_a_combo.emit(combo_score)
		print(">>> all shapes of colours combo")

# checks if last 6 collected mooks are of the same shape and different colours
func _all_colours_of_shape_check() -> void:
	if _same_shape_unique_colour_streak == _unique_colours.size():
		_all_colours_of_shape_counter += 1
		# calculate the combo score and add it to the total
		var mook_score_total: int = _calculate_mook_score_in_combo(_unique_colours.size())
		var combo_score = mook_score_total * Global.ALL_COLOURS_OF_SHAPE_MULTIPLIER
		_combo_score_total += combo_score
		scored_a_combo.emit(combo_score)
		print(">>> all colours of shapes combo")

# calculates the sum of the score values of each mook in the combo
func _calculate_mook_score_in_combo(combo_size: int) -> int:
	var mooks_in_array: int = _last_collected_mooks.size()
	var mook_score_total: int = 0
	if mooks_in_array >= combo_size:
		for i in combo_size:
			var mook: MookStats = _last_collected_mooks[mooks_in_array - 1 - i]
			match mook.rarity:
				Global.Rarities.COMMON:
					mook_score_total += Global.BASE_SCORE
					_no_combo_score_total -= Global.BASE_SCORE
				Global.Rarities.RARE:
					mook_score_total += Global.RARE_SCORE
					_no_combo_score_total -= Global.RARE_SCORE
				Global.Rarities.LEGENDARY:
					mook_score_total += Global.LEGENDARY_SCORE
					_no_combo_score_total -= Global.LEGENDARY_SCORE
		return mook_score_total
	else:
		print("ERROR: Combo size is larger than last collected mooks array")
		return 0

func _calculate_final_score() -> int:
	return _combo_score_total + _no_combo_score_total
