class_name OptionsMenu
extends Control

@onready var back_button: Button = %BackButton

@onready var master_slider: HSlider = $MarginContainer/VBoxContainer/MasterVolumeContainer/SliderContainer/MasterSlider
@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/MusicVolumeContainer3/SliderContainer/MusicSlider
@onready var sound_slider: HSlider = $MarginContainer/VBoxContainer/SoundVolume/SliderContainer/SoundSlider


func _ready():
	
	# Connects to functions
	back_button.pressed.connect(_on_back_pressed)
	
	# Connects hover sfx
	back_button.mouse_entered.connect(_on_mouse_entered)
	master_slider.mouse_entered.connect(_on_mouse_entered)
	music_slider.mouse_entered.connect(_on_mouse_entered)
	sound_slider.mouse_entered.connect(_on_mouse_entered)


## Deals with input to pause the game and show menu
func _input(_event):
	if Input.is_action_just_pressed("pause_game"):
		if visible:  
			_play_click_sfx()
		self.visible = false


func _play_click_sfx() -> void:
	AudioManager.instance.play_click_sfx()


# Back to main menu
func _on_back_pressed() -> void:
	_play_click_sfx()
	self.visible = false


func _on_mouse_entered() -> void:
	AudioManager.play_hover_sfx()
