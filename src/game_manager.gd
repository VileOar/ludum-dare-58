class_name GameManager
extends Node2D

signal end_game

@export var _hud_ref: Hud
@export var _pause_menu_ref: PauseMenu
@export var _night_shade_ref: ColorRect

@export var _time_limit_timer: Timer
@export var _boom_box: BoomBox

var _bag_slots_remaining: int = Global.MAX_BAG_SLOTS
# time remaining before the game ends (seconds)
var _time_left: float = Global.TIME_LIMIT

var _is_time_warning_played: bool = false
var _interval_timer := 0.0


func _ready() -> void:
	# reset all score related stuff
	ScoreManager.reset_all()
	# initialize hud
	_hud_ref.update_bag_slots_display(_bag_slots_remaining)
	_time_limit_timer.start(_time_left)
	# connect signals
	_pause_menu_ref.connect("on_resume", _resume_game)
	_pause_menu_ref.connect("on_quit", _quit_to_title)


func _physics_process(delta: float) -> void:
	# not worth running if it didn't happen yet
	if !_is_time_warning_played:
		return
		
	_time_left = _time_limit_timer.time_left
	_interval_timer += delta
	
	if _interval_timer >= Global.TIME_INTERVAL_TO_UPDATE_PITCH:
		_interval_timer = 0.0
		if _is_time_warning_played && _time_left > 0: 
			_boom_box.speed_up_current_music()


func _process(_delta: float) -> void:
	_time_left = _time_limit_timer.time_left
	if _is_time_warning_played == false && _time_left < Global.WARNING_OF_TIME_LIMIT:
		_is_time_warning_played = true
		_hud_ref.play_animation_warning_about_time()
		AudioManager.instance.play_audio("TimerWarning")
		
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
	DexManager.on_collect_mook(mook.get_stats())
	_hud_ref.update_bag_slot_icons(ScoreManager.get_last_collected_mooks())
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
	_reset_audio()
	Global.set_end_message(end_message)
	Global.set_final_score(ScoreManager.calculate_total_score())
	var change_scene := func():
		get_tree().change_scene_to_file(Global.SCORE_SCENE_FILEPATH)
	change_scene.call_deferred()
	
	
func _reset_audio() -> void:
	_boom_box.set_original_pitch_in_current_music()
	_is_time_warning_played = false
	
