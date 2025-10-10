extends Control


@export var _spawn_icon_time: float = 0.15
@export var _time_interval_between_icon_combo_animation: float = 0.1
@export var _target_scale_icon_combo_animation: Vector2 = Vector2(7.0, 7.0)
@export var _duration_of_combo_display: float = 1.5
@export var _score_scale_animation_target: Vector2 = Vector2(1.2, 1.2)

var _all_collected_mooks: Array[MookStats]

const BACKGROUND_MUSIC : String = "EndGameMusic"

# variables used for the combo display
var _has_scored_a_combo: bool = false
var _combo_length: int
var _combo_score: int


func _ready() -> void:
	# update title with end message
	$Title.text = Global.get_end_message()
	_play_end_game_audio()
	
	_all_collected_mooks = ScoreManager.get_all_collected_mooks()
	ScoreManager.reset_all()
	ScoreManager.scored_a_combo.connect(_on_scored_a_combo)
	
	spawn_mook_icons()


func spawn_mook_icons():
	var mook_icon_scene: PackedScene = load("uid://bo6nia8h14s4y")
	
	for mook in _all_collected_mooks:
		var mook_icon: Control = mook_icon_scene.instantiate()
		
		var mook_icon_texture: TextureRect = mook_icon.get_node("TextureRect")
		mook_icon_texture.texture = Global.shape_icons[mook.shape]
		mook_icon_texture.modulate = Global.colour_values[mook.colour]
		
		$GridContainer.add_child(mook_icon)
		_play_special_sfx()
		
		ScoreManager.on_collect(mook)
		_update_score_label(ScoreManager.calculate_total_score())
		
		if _has_scored_a_combo:
			_has_scored_a_combo = false
			
			var animation_player: AnimationPlayer = mook_icon.get_node("TextureRect/AnimationPlayer")
			if animation_player.is_playing():
				await animation_player.animation_finished

			_play_combo_special_sfx()
			await _display_combo()	# we have to wait for display combo to finish animating
		
		await get_tree().create_timer(_spawn_icon_time).timeout
	$Death.play("end" if Global.get_final_score() >= Global.GOOD_SCORE_THRESHOLD else "blink")


func _display_combo() -> void:
	var target_position_container: Control
	match _combo_length:
		3:
			target_position_container = $ThreeComboPositions
		4:
			target_position_container = $FourComboPositions
		5:
			target_position_container = $FiveComboPositions
		6:
			target_position_container = $SixComboPositions
	
	for i in range(_combo_length, 0, -1):
		var mook_icon: TextureRect = $GridContainer.get_child($GridContainer.get_child_count() - i).get_node("TextureRect")
		
		# add a delay between each animation except for last one
		if (i != 1):
			_animate_combo_icon(mook_icon, target_position_container.get_child(_combo_length - i).global_position)
			await get_tree().create_timer(_time_interval_between_icon_combo_animation).timeout
		else:
			# on last animation wait for it to finish
			await _animate_combo_icon(mook_icon, target_position_container.get_child(_combo_length - i).global_position)


func _animate_combo_icon(mook_icon: TextureRect, mook_target_position: Vector2):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC)

	tween.tween_property(mook_icon, "scale", _target_scale_icon_combo_animation, 0.5)
	tween.set_parallel(true)
	tween.tween_property(mook_icon, "global_position", mook_target_position, 0.5)
	tween.set_parallel(false)
	tween.tween_interval(_duration_of_combo_display)
	tween.tween_property(mook_icon, "position", Vector2(0.0, 0.0), 0.5)
	tween.set_parallel(true)
	tween.tween_property(mook_icon, "scale", Vector2(1.0, 1.0), 0.5)

	await tween.finished


func _on_scored_a_combo(combo_score: int, combo_length: int) -> void:
	_has_scored_a_combo = true
	_combo_score = combo_score
	_combo_length = combo_length


func _update_score_label(new_score: int) -> void:
	$Score/ScoreValue.text = str(new_score)
	var tween = get_tree().create_tween()
	tween.tween_property($Score/ScoreValue, "scale", _score_scale_animation_target, 0.075)
	tween.tween_property($Score/ScoreValue, "scale", Vector2(1.0, 1.0), 0.075)


func _on_play_again_pressed() -> void:
	_play_click_sfx()
	AudioManager.instance.fade_out_music(BACKGROUND_MUSIC)
	var change_scene := func():
		get_tree().change_scene_to_file(Global.LEVEL_SCENE_FILEPATH)
	change_scene.call_deferred()


func _on_soul_dex_pressed() -> void:
	_play_click_sfx()
	$DexMenu.show()


func _on_quit_pressed() -> void:
	_play_click_sfx()
	AudioManager.instance.fade_out_music(BACKGROUND_MUSIC)
	var change_scene := func():
		get_tree().change_scene_to_file(Global.TITLE_SCENE_FILEPATH)
	change_scene.call_deferred()


#region Audio
func _play_end_game_audio() -> void:
	AudioManager.instance.play_audio(BACKGROUND_MUSIC)


func _play_special_sfx() -> void:
	var _final_score = ScoreManager.calculate_total_score()
	
	if _final_score < 299:
		AudioManager.instance.play_audio_random_pitch("MookScore1", 1.2, 1.5)
		
	if _final_score > 299 && _final_score < 599:
		AudioManager.instance.play_audio_random_pitch("MookScore2", 1.5, 1.7)
	
	if _final_score > 600:
		AudioManager.instance.play_audio_random_pitch("MookScore3", 1.7, 1.9)


func _play_combo_special_sfx() -> void:
	AudioManager.instance.play_audio_random_pitch("ComboScore", 1.5, 1.5)
	

func _play_click_sfx() -> void:
	AudioManager.play_click_sfx()


func _play_hover_sfx() -> void:
	AudioManager.play_hover_sfx()


func _on_button_mouse_entered():
	_play_hover_sfx()
#endregion
