class_name GameManager
extends Node2D

signal end_game

@export var _hud_ref: Hud
@export var _pause_menu_ref: PauseMenu
@export var _night_shade_ref: ColorRect
@export var _transition_overlay_ref: TransitionOverlay

@export var _time_limit_timer: Timer
@export var _boom_box: BoomBox

const END_MESSAGE_DURATION: float = 2.8
const FADE_OUT_DURATION: float = 1.0

var _bag_slots_remaining: int = Global.MAX_BAG_SLOTS
# time remaining before the game ends (seconds)
var _time_left: float = Global.TIME_LIMIT

var _is_time_warning_played: bool = false
var _is_game_over: bool = false
var _is_game_paused: bool = false
var _interval_timer := 0.0

enum EndConditions{
	FULL_BAG,
	TIMEOUT
}

func _ready() -> void:
	# reset all score related stuff
	ScoreManager.reset_score()
	# initialize hud
	_hud_ref.update_bag_slots_display(_bag_slots_remaining)
	_time_limit_timer.start(_time_left)
	# connect signals
	_pause_menu_ref.connect("on_resume", _resume_game)
	_pause_menu_ref.connect("on_quit", _quit_to_title)
	_transition_overlay_ref.connect("fade_out_end", _go_to_score_screen)


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
		
	if _time_left > 0 and !_is_game_over:
		_hud_ref.update_timer(_time_left)
		
	elif !_is_game_over:
		_is_game_over = true
		_hud_ref.update_timer(0)
		_end_game(EndConditions.TIMEOUT)

func _input(event):
	if event.is_action_pressed("pause") and !_is_game_over:
		_on_pause_key_press()

func remove_bag_slot() -> void:
	_bag_slots_remaining -= 1
	_hud_ref.update_bag_slots_display(_bag_slots_remaining)
	if _bag_slots_remaining == 0 and !_is_game_over:
		_is_game_over = true
		_end_game(EndConditions.FULL_BAG)

func collect_mook(mook: Mook) -> void:
	if _bag_slots_remaining > 0:
		ScoreManager.on_collect(mook.get_stats())
		DexManager.on_collect_mook(mook.get_stats())
		_hud_ref.update_bag_slot_icons(ScoreManager.get_last_collected_mooks())
		remove_bag_slot()

func _on_pause_key_press() -> void:
	if !_is_game_paused:
		_pause_game()
	elif _pause_menu_ref.can_be_closed():
		_resume_game()

func _pause_game() -> void:
	_is_game_paused = true
	Global.set_is_input_blocked(true)
	_night_shade_ref.hide()
	_hud_ref.hide()
	_pause_menu_ref.show()
	Engine.time_scale = 0

func _resume_game() -> void:
	_is_game_paused = false
	_pause_menu_ref.hide()
	Global.set_is_input_blocked(false)
	_night_shade_ref.show()
	_hud_ref.show()
	Engine.time_scale = 1

func _quit_to_title() -> void:
	Engine.time_scale = 1
	Global.set_is_input_blocked(false)
	emit_signal("end_game")

func _end_game(end_condition: EndConditions) -> void:
	Global.set_is_input_blocked(true)
	# set the end message for the game and score screens
	match end_condition:
		EndConditions.FULL_BAG:
			_hud_ref.display_end_message_bag()
			Global.set_end_message(Global.END_MESSAGE_FULL_BAG)
		EndConditions.TIMEOUT:
			_hud_ref.display_end_message_time()
			Global.set_end_message(Global.END_MESSAGE_TIMEOUT)
	# store the final score
	var final_score: int = ScoreManager.calculate_total_score()
	Global.set_final_score(final_score)
	# if the score is at or above the excellent treshold, change the score screen message
	if final_score >= Global.EXCELLENT_SCORE_THRESHOLD:
		Global.set_end_message(Global.END_MESSAGE_EXCELLENT_SCORE)
	
	# wait for end message duration
	await get_tree().create_timer(END_MESSAGE_DURATION).timeout
	# then play fade out transition
	_transition_overlay_ref.fade_out(FADE_OUT_DURATION)
	
func _go_to_score_screen() -> void:
	Global.set_is_input_blocked(false)
	emit_signal("end_game")
	_reset_audio()
	Global.deferred_change_scene(Global.SCORE_SCENE_FILEPATH)

func _reset_audio() -> void:
	_boom_box.set_original_pitch_in_current_music()
	_is_time_warning_played = false
