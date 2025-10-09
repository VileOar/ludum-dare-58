extends Node2D

signal scored_a_combo(combo_score: int, combo_length: int)

# count how many mooks were collected (+by rarity)
var _collected_mooks_total: int = 0
var _collected_commons_counter: int = 0
var _collected_rares_counter: int = 0
var _collected_legendaries_counter: int = 0

# count how many times a combo was made
var _combo_counter: int = 0

# array that stores the stats of all collected mooks
var _all_collected_mooks: Array[MookStats] = []
# array that stores the stats of the last few collected mooks
var _last_collected_mooks: Array[MookStats] = []
# max amont of the last collected mooks that are kept stored
var _max_last_collected_mooks: int = 6

# stores the total score of all combos done
var _combo_score_total: int = 0
# stores the total score of mooks collected outside of combos
var _no_combo_score_total: int = 0

# stores the amount of mooks collected since a combo of each length
var _mooks_since_combo_of_length: Dictionary [int, int]

func _ready() -> void:
	_reset_mooks_since_combo_of_length()

func _reset_mooks_since_combo_of_length() -> void:
	var combo_lengths: Array[int] = []
	for combo_rule: ComboRule in Global.combo_rules.values():
		var combo_length = combo_rule.get_combo_length()
		if !combo_lengths.has(combo_length):
			combo_lengths.append(combo_length)
	for length in combo_lengths:
		_mooks_since_combo_of_length[length] = 0

func on_collect(collected_mook : MookStats) -> void:
	# add collected mook to respective arrays
	_all_collected_mooks.push_back(collected_mook)
	_update_last_collected_mooks(collected_mook)
	
	# count collected mook
	_collected_mooks_total += 1
	for length in _mooks_since_combo_of_length:
		_mooks_since_combo_of_length[length] += 1
	# update score and mook counters based on rarity
	match collected_mook.rarity:
		Global.Rarities.COMMON:
			_collected_commons_counter += 1
			_no_combo_score_total += Global.BASE_SCORE
		Global.Rarities.RARE:
			_collected_rares_counter += 1
			_no_combo_score_total += Global.RARE_SCORE
		Global.Rarities.LEGENDARY:
			_collected_legendaries_counter += 1
			_no_combo_score_total += Global.LEGENDARY_SCORE
	
	# don't check for combos if less than 2 mooks have been collected
	if _collected_mooks_total < 2:
		return
	# check for combos
	for combo in Global.Combos.values():
		_combo_check(combo)

# adds mook stats to the last collected mooks array and deletes the oldest if it is full
func _update_last_collected_mooks(collected_mook: MookStats):
	_last_collected_mooks.push_back(collected_mook)
	if _last_collected_mooks.size() > _max_last_collected_mooks:
		_last_collected_mooks.pop_front()

# checks if combo requirements are met, then apllies combo
func _combo_check(combo: Global.Combos) -> void:
	var combo_rule: ComboRule = Global.combo_rules[combo]
	var combo_length: int = combo_rule.get_combo_length()
	# stop check if not enough mooks have been collected
	# since last time a combo of this length was scored
	if _mooks_since_combo_of_length[combo_length] < combo_length:
		return
	# check all combo requirements and stop the check if any of them fail
	if combo_rule.is_same_colour_req():
		if !_same_colour_check(combo_length):
			return
	if combo_rule.is_same_shape_req():
		if !_same_shape_check(combo_length):
			return
	if combo_rule.is_unique_colours_req():
		if !_unique_colours_check(combo_length):
			return
	if combo_rule.is_unique_shapes_req():
		if !_unique_shapes_check(combo_length):
			return
	if combo_rule.is_colour_sequence_req():
		if !_colour_seq_check(combo_length, combo_rule.get_colour_sequence()):
			return
	if combo_rule.is_shape_sequence_req():
		if !_shape_seq_check(combo_length, combo_rule.get_shape_sequence()):
			return
	if combo_rule.is_colours_restricted():
		if !_allowed_colours_check(combo_length, combo_rule.get_allowed_colours()):
			return
	if combo_rule.is_shapes_restricted():
		if !_allowed_shapes_check(combo_length, combo_rule.get_allowed_shapes()):
			return
	# reset mooks since combo of this length (putting combos of this length on "cooldown")
	_mooks_since_combo_of_length[combo_length] = 0
	# if all previous requirements are met, score the combo
	_combo_counter += 1
	var combo_score: int = 0
	match combo_rule.get_bonus_type():
		Global.BonusTypes.FLAT:
			combo_score = int(combo_rule.get_bonus_value())
		Global.BonusTypes.MULTIPLIER:
			var mook_score: int = _calculate_mook_score(combo_length)
			combo_score = (
				round(mook_score * combo_rule.get_bonus_value()) - mook_score
				)
	_combo_score_total += combo_score
	scored_a_combo.emit(combo_score, combo_length)

# check if given amount of last mooks collected are of the same colour
func _same_colour_check(mooks_to_check: int) -> bool:
	var last_mook_idx: int = _last_collected_mooks.size() - 1
	for i in mooks_to_check - 1:
		var mookA: MookStats = _last_collected_mooks[last_mook_idx - i]
		var mookB: MookStats = _last_collected_mooks[last_mook_idx - i - 1]
		if mookA.colour != mookB.colour:
			return false
	return true

# check if given amount of last mooks collected are of the same shape
func _same_shape_check(mooks_to_check: int) -> bool:
	var last_mook_idx: int = _last_collected_mooks.size() - 1
	for i in mooks_to_check - 1:
		var mookA: MookStats = _last_collected_mooks[last_mook_idx - i]
		var mookB: MookStats = _last_collected_mooks[last_mook_idx - i - 1]
		if mookA.shape != mookB.shape:
			return false
	return true

# check if given amount of last mooks collected have unique colours
func _unique_colours_check(mooks_to_check: int) -> bool:
	var last_mook_idx: int = _last_collected_mooks.size() - 1
	var unique_colours: Array = Global.Colours.values()
	for i in mooks_to_check:
		var mook: MookStats = _last_collected_mooks[last_mook_idx - i]
		if unique_colours.has(mook.colour):
			unique_colours.erase(mook.colour)
		else:
			return false
	return true

# check if given amount of last mooks collected have unique shapes
func _unique_shapes_check(mooks_to_check: int) -> bool:
	var last_mook_idx: int = _last_collected_mooks.size() - 1
	var unique_shapes: Array = Global.Colours.values()
	for i in mooks_to_check:
		var mook: MookStats = _last_collected_mooks[last_mook_idx - i]
		if unique_shapes.has(mook.shape):
			unique_shapes.erase(mook.shape)
		else:
			return false
	return true

# check if given amount of last mooks collected follow a given colour sequence
func _colour_seq_check(mooks_to_check: int, req_colour_seq: Array[Global.Colours]) -> bool:
	var last_mook_idx: int = _last_collected_mooks.size() - 1
	var colour_seq: Array[Global.Colours] = []
	for i in mooks_to_check:
		var mook: MookStats = _last_collected_mooks[last_mook_idx - i]
		colour_seq.append(mook.colour)
	colour_seq.reverse()
	if colour_seq == req_colour_seq:
		return true
	return false

# check if given amount of last mooks collected follow a given shape sequence
func _shape_seq_check(mooks_to_check: int, req_shape_seq: Array[Global.Shapes]) -> bool:
	var last_mook_idx: int = _last_collected_mooks.size() - 1
	var shape_seq: Array[Global.Shapes] = []
	for i in mooks_to_check:
		var mook: MookStats = _last_collected_mooks[last_mook_idx - i]
		shape_seq.append(mook.shape)
	shape_seq.reverse()
	if shape_seq == req_shape_seq:
		return true
	return false

# check if given amount of last mooks collected are of allowed colours
func _allowed_colours_check(mooks_to_check: int, allowed_colours: Array[Global.Colours]) -> bool:
	var last_mook_idx: int = _last_collected_mooks.size() - 1
	for i in mooks_to_check:
		var mook: MookStats = _last_collected_mooks[last_mook_idx - i]
		if !allowed_colours.has(mook.colour):
			return false
	return true

# check if given amount of last mooks collected are of allowed shapes
func _allowed_shapes_check(mooks_to_check: int, allowed_shapes: Array[Global.Shapes]) -> bool:
	var last_mook_idx: int = _last_collected_mooks.size() - 1
	for i in mooks_to_check:
		var mook: MookStats = _last_collected_mooks[last_mook_idx - i]
		if !allowed_shapes.has(mook.shape):
			return false
	return true

# calculates the sum of the score values of each mook in a combo
func _calculate_mook_score(combo_size: int) -> int:
	var mooks_in_array: int = _last_collected_mooks.size()
	if mooks_in_array >= combo_size:
		var mook_score_total: int = 0
		for i in combo_size:
			var mook: MookStats = _last_collected_mooks[mooks_in_array - 1 - i]
			match mook.rarity:
				Global.Rarities.COMMON:
					mook_score_total += Global.BASE_SCORE
				Global.Rarities.RARE:
					mook_score_total += Global.RARE_SCORE
				Global.Rarities.LEGENDARY:
					mook_score_total += Global.LEGENDARY_SCORE
		return mook_score_total
	else:
		print("ERROR: Combo size is larger than last collected mooks array")
		return 0

func calculate_total_score() -> int:
	return _combo_score_total + _no_combo_score_total

func reset_all() -> void:
	_collected_mooks_total = 0
	_collected_commons_counter = 0
	_collected_rares_counter = 0
	_collected_legendaries_counter = 0
	_combo_counter = 0
	_all_collected_mooks = []
	_last_collected_mooks.clear()
	_combo_score_total = 0
	_no_combo_score_total = 0
	_reset_mooks_since_combo_of_length()

func get_all_collected_mooks() -> Array[MookStats]:
	return _all_collected_mooks

func get_last_collected_mooks() -> Array[MookStats]:
	return _last_collected_mooks
