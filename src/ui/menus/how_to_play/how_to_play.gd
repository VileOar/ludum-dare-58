extends Control

signal how_to_play_return

func _ready():
	$HowToPlayReturn.pressed.connect(_on_how_to_play_return_pressed)
	$HowToPlayReturn.mouse_entered.connect(_on_button_mouse_entered)
	visible = false
	
	
func _on_how_to_play_return_pressed() -> void:
	AudioManager.play_click_sfx()
	hide()
	emit_signal("how_to_play_return")
	

func _on_button_mouse_entered():
	AudioManager.play_hover_sfx()
