extends ColorRect

signal how_to_play_return

@onready var combos: Control = $Combos
@onready var how_to_play_info: Control = $HowToPlayInfo


func _ready():
	$HowToPlayInfo/HowToPlayReturn.pressed.connect(_on_how_to_play_return_pressed)
	$HowToPlayInfo/HowToPlayReturn.mouse_entered.connect(_on_button_mouse_entered)
	combos.combos_returned.connect(_on_combos_returned_pressed)
	#visible = false
	
	
func _on_how_to_play_return_pressed() -> void:
	AudioManager.play_click_sfx()
	hide()
	emit_signal("how_to_play_return")
	

func _on_combos_returned_pressed() -> void:
	display_how_to_play(true)

func _on_button_mouse_entered():
	AudioManager.play_hover_sfx()

func _on_combos_btn_pressed() -> void:
	AudioManager.play_click_sfx()
	display_how_to_play(false)
	
func display_how_to_play(is_how_to_play : bool): 
	how_to_play_info.visible = is_how_to_play
	combos.visible = !is_how_to_play
