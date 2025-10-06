class_name GameManager
extends Node2D

@export var _score_screen: PackedScene
@export var _hud_ref: Hud

@export var _time_limit_timer: Timer

var _bag_slots_remaining: int = Global.MAX_BAG_SLOTS
# time remaining before the game ends (seconds)
var _time_left: float = Global.TIME_LIMIT

func _ready() -> void:
	# initialize hud
	_hud_ref.update_bag_slots_display(_bag_slots_remaining)
	_time_limit_timer.start(_time_left)

func _process(_delta: float) -> void:
	_time_left = _time_limit_timer.time_left
	if _time_left > 0:
		_hud_ref.update_timer(_time_left)
	else:
		_hud_ref.update_timer(0)
		_end_game()

func remove_bag_slot() -> void:
	if _bag_slots_remaining > 0:
		_bag_slots_remaining -= 1
		_hud_ref.update_bag_slots_display(_bag_slots_remaining)
		if _bag_slots_remaining == 0:
			_end_game()

func collect_mook(mook: Mook) -> void:
	ScoreManager.on_collect(mook.get_stats())
	_hud_ref.update_bag_slot_icons(ScoreManager._last_collected_mooks)
	remove_bag_slot()

func _end_game() -> void:
	Global.set_final_score(ScoreManager._calculate_final_score())
	var change_scene := func():
		get_tree().change_scene_to_packed(_score_screen)
	change_scene.call_deferred()
