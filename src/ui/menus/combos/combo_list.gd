extends Panel

func _ready() -> void:
	hide()

func _on_return_pressed() -> void:
	AudioManager.play_click_sfx()
	hide()

func _on_button_mouse_entered():
	AudioManager.play_hover_sfx()
