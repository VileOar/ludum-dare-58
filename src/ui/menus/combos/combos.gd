extends Control

signal combos_returned

func _ready() -> void:
	visible = false


func _on_combo_return_pressed() -> void:
	AudioManager.play_click_sfx()
	emit_signal("combos_returned")


func _on_button_mouse_entered():
	AudioManager.play_hover_sfx()
