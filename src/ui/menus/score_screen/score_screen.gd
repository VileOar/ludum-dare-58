extends Control


var _score_string : String = "Score {score}"
var _spawn_icon_time: float = 0.15


func _ready() -> void:
	_play_end_game_audio()
	_update_score_label(Global.get_final_score())
	
	spawn_mook_icons()


func spawn_mook_icons():
	var mook_icon_scene: PackedScene = load("uid://bo6nia8h14s4y")
	
	for mook in ScoreManager._all_collected_mooks:
		var mook_icon: Control = mook_icon_scene.instantiate()
		
		var mook_icon_texture: TextureRect = mook_icon.get_node("TextureRect")
		mook_icon_texture.texture = Global.shape_icons[mook.shape]
		mook_icon_texture.modulate = Global.colour_values[mook.colour]
		
		$GridContainer.add_child(mook_icon)
		
		await get_tree().create_timer(_spawn_icon_time).timeout


func _update_score_label(new_score: int) -> void:
	$Score.text = _score_string.format({"score": new_score})


#region Audio
func _play_end_game_audio() -> void:
	AudioManager.instance.play_audio("EndGameMusic")

#endregion
