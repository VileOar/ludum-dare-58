extends Control

signal combos_returned

func _ready() -> void:
	visible = false

func _on_how_to_play_btn_pressed() -> void:
	AudioManager.play_click_sfx()
	emit_signal("combos_returned")
	hide()

func _on_button_mouse_entered():
	AudioManager.play_hover_sfx()
