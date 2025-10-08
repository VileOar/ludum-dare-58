extends Control


@export var _spawn_icon_time: float = 0.15

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
			_display_combo()
			_play_combo_special_sfx()
			
			await get_tree().create_timer(2.0).timeout
		
		await get_tree().create_timer(_spawn_icon_time).timeout
	$Death.play("end" if Global.get_final_score() >= Global.GOOD_SCORE_THRESHOLD else "blink")


func _display_combo() -> void:
	match _combo_length:
		4:
			# get last four mooks of the grid
			for i in range(4, 0, -1):
				var mook_icon: Control = $GridContainer.get_child($GridContainer.get_child_count() - i)
				_animate_combo_icon(mook_icon, $FourComboPositions.get_child(i - 1).global_position)
		5:
			# get last five mooks of the grid
			for i in range(5, 0, -1):
				var mook_icon: Control = $GridContainer.get_child($GridContainer.get_child_count() - i)
				_animate_combo_icon(mook_icon, $FiveComboPositions.get_child(i - 1).global_position)
		6:
			# get last six mooks of the grid
			for i in range(6, 0, -1):
				var mook_icon: Control = $GridContainer.get_child($GridContainer.get_child_count() - i)
				_animate_combo_icon(mook_icon, $SixComboPositions.get_child(i - 1).global_position)


func _animate_combo_icon(mook_icon, mook_target_position):
	var animation_player: AnimationPlayer = mook_icon.get_node("TextureRect/AnimationPlayer")
	if animation_player.is_playing():
		await animation_player.animation_finished
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(mook_icon.get_node("TextureRect"), "scale", Vector2(7.0, 7.0), 0.5)
	tween.set_parallel(true)
	tween.tween_property(mook_icon.get_node("TextureRect"), "global_position", mook_target_position, 0.5)
	tween.set_parallel(false)
	tween.tween_property(mook_icon.get_node("TextureRect"), "scale", Vector2(7.0, 7.0), 1.0)
	tween.tween_property(mook_icon.get_node("TextureRect"), "position", Vector2(0.0, 0.0), 0.5)
	tween.set_parallel(true)
	tween.tween_property(mook_icon.get_node("TextureRect"), "scale", Vector2(1.0, 1.0), 0.5)


func _on_scored_a_combo(combo_score: int, combo_length: int) -> void:
	_has_scored_a_combo = true
	_combo_score = combo_score
	_combo_length = combo_length


func _update_score_label(new_score: int) -> void:
	$Score/ScoreValue.text = str(new_score)
	var tween = get_tree().create_tween()
	tween.tween_property($Score/ScoreValue, "scale", Vector2(1.2, 1.2), 0.075)
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
	await get_tree().create_timer(0.5).timeout
	AudioManager.instance.play_audio_random_pitch("ComboScore", 1.5, 1.5)
	

func _play_click_sfx() -> void:
	AudioManager.play_click_sfx()
	
func _play_hover_sfx() -> void:
	AudioManager.play_hover_sfx()
	
func _on_button_mouse_entered():
	_play_hover_sfx()
#endregion
