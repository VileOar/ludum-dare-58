extends Control

func _on_return_pressed() -> void:
	_play_click_sfx()
	self.hide()

#region Audio
func _play_click_sfx() -> void:
	AudioManager.play_click_sfx()
	
func _play_hover_sfx() -> void:
	AudioManager.play_hover_sfx()
	
func _on_button_mouse_entered():
	_play_hover_sfx()
#endregion
