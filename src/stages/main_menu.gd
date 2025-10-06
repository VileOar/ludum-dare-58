extends Control

@onready var _title_screen : Control = $TitleScreen
@onready var _options_screen : Control = $OptionsMenu
@onready var _credits_screen : Control = $Credits
@onready var _how_to_play_screen : Control = $HowToPlay
@onready var _collection_screen : Control = $DexMenu

func _ready() -> void:
	_start_main_menu_music()


func _on_play_button_pressed() -> void:
	_play_click_sfx()
	_stop_main_menu_music()
	get_tree().change_scene_to_file(Global.LEVEL_SCENE_FILEPATH)

func _on_collection_button_pressed() -> void:
	_play_click_sfx()
	_collection_screen.show()

func _on_options_button_pressed() -> void:
	_play_click_sfx()
	_options_screen.show()

func _on_how_to_play_button_pressed() -> void:
	_play_click_sfx()
	_title_screen.hide()
	_how_to_play_screen.show()

func _on_how_to_play_return_pressed() -> void:
	_play_click_sfx()
	_how_to_play_screen.hide()
	_title_screen.show()

func _on_credits_button_pressed() -> void:
	_play_click_sfx()
	_title_screen.hide()
	_credits_screen.show()

func _on_credits_return_pressed() -> void:
	_play_click_sfx()
	_credits_screen.hide()
	_title_screen.show()

func _on_quit_button_pressed() -> void:
	_play_click_sfx()
	get_tree().quit()


#region Audio
func _start_main_menu_music() -> void:
	AudioManager.instance.play_audio("MainMenuMusic")
	
func _stop_main_menu_music() -> void:
	AudioManager.instance.stop_audio("MainMenuMusic")
	
func _play_click_sfx() -> void:
	AudioManager.play_click_sfx()
	
func _play_hover_sfx() -> void:
	AudioManager.play_hover_sfx()
	
func _on_button_mouse_entered():
	_play_hover_sfx()
#endregion
