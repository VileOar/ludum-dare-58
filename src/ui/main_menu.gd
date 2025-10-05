extends Control

@export var _game_scene: PackedScene

func _ready() -> void:
	_start_main_menu_music()


func _on_play_button_pressed() -> void:
	_stop_main_menu_music()
	get_tree().change_scene_to_packed(_game_scene)

func _on_collection_button_pressed() -> void:
	pass # Replace with function body.

func _on_options_button_pressed() -> void:
	pass # Replace with function body.

func _on_credits_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
	
#region Audio
func _start_main_menu_music() -> void:
	AudioManager.instance.play_audio("MainMenuMusic")
	
func _stop_main_menu_music() -> void:
	AudioManager.instance.stop_audio("MainMenuMusic")
