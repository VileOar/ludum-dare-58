class_name PauseMenu
extends Control

signal on_resume
signal on_quit

func _on_resume_pressed() -> void:
	_play_click_sfx()
	on_resume.emit()

func _on_soul_dex_pressed() -> void:
	_play_click_sfx()
	$DexMenu.show()

func _on_options_pressed() -> void:
	$OptionsMenu.show()

func _on_quit_pressed() -> void:
	on_quit.emit()
	_play_click_sfx()
	Global.deferred_change_scene(Global.TITLE_SCENE_FILEPATH)

func can_be_closed() -> bool:
	if $OptionsMenu.visible:
		return false
	if $DexMenu.visible:
		return false
	return true

#region audio
func _play_click_sfx() -> void:
	AudioManager.play_click_sfx()
	
func _play_hover_sfx() -> void:
	AudioManager.play_hover_sfx()
	
func _on_button_mouse_entered():
	_play_hover_sfx()
#endregion
