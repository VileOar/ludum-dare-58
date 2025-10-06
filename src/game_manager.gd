class_name GameManager
extends Node2D

signal end_game

@export var _hud_ref: Hud
@export var _pause_menu_ref: PauseMenu
@export var _night_shade_ref: ColorRect

@export var _time_limit_timer: Timer

var _bag_slots_remaining: int = Global.MAX_BAG_SLOTS
# time remaining before the game ends (seconds)
var _time_left: float = Global.TIME_LIMIT

func _ready() -> void:
	# initialize hud
	_hud_ref.update_bag_slots_display(_bag_slots_remaining)
	_time_limit_timer.start(_time_left)
	# connect signals
	_pause_menu_ref.connect("on_resume", _resume_game)
	_pause_menu_ref.connect("on_quit", _quit_to_title)

func _process(_delta: float) -> void:
	_time_left = _time_limit_timer.time_left
	if _time_left > 0:
		_hud_ref.update_timer(_time_left)
	else:
		_hud_ref.update_timer(0)
		_end_game(Global.END_MESSAGE_TIMEOUT)

func _input(event):
	if event.is_action_pressed("pause"):
		_pause_game()

func remove_bag_slot() -> void:
	if _bag_slots_remaining > 0:
		_bag_slots_remaining -= 1
		_hud_ref.update_bag_slots_display(_bag_slots_remaining)
		if _bag_slots_remaining == 0:
			_end_game(Global.END_MESSAGE_FULL_BAG)

func collect_mook(mook: Mook) -> void:
	ScoreManager.on_collect(mook.get_stats())
	_hud_ref.update_bag_slot_icons(ScoreManager._last_collected_mooks)
	remove_bag_slot()

func _pause_game() -> void:
	Global.set_is_paused(true)
	_night_shade_ref.hide()
	_hud_ref.hide()
	_pause_menu_ref.show()
	Engine.time_scale = 0

func _resume_game() -> void:
	Global.set_is_paused(false)
	_night_shade_ref.show()
	_hud_ref.show()
	Engine.time_scale = 1

func _quit_to_title() -> void:
	Engine.time_scale = 1
	Global.set_is_paused(false)
	emit_signal("end_game")

func _end_game(end_message: String) -> void:
	emit_signal("end_game")
	Global.set_end_message(end_message)
	Global.set_final_score(ScoreManager._calculate_final_score())
	var change_scene := func():
		get_tree().change_scene_to_file(Global.SCORE_SCENE_FILEPATH)
	change_scene.call_deferred()
	
