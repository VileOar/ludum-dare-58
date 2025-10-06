extends Control

var _score_string : String = "Score {score}"

func _ready() -> void:
	_update_score_label(Global.get_final_score())
	_play_end_game_audio()
	
	for mook in ScoreManager._all_collected_mooks:
		var texture_rect = TextureRect.new()
		
		texture_rect.custom_minimum_size = Vector2(64.0, 64.0)
		texture_rect.texture = Global.shape_icons[mook.shape]
		texture_rect.modulate = Global.colour_values[mook.colour]
		
		$GridContainer.add_child(texture_rect)


func _update_score_label(new_score: int) -> void:
	$Score.text = _score_string.format({"score": new_score})


#region Audio
func _play_end_game_audio() -> void:
	AudioManager.instance.play_audio("EndGameMusic")

#endregion
