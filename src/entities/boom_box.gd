extends Sprite2D

var previous_music : String
var current_music : String
var _is_changing_music := false
var _festival_music_dictionary_with_bpm : Dictionary = {}


func _ready() -> void:
	_setup_festival_music_dictionary()
	start_boombox()
	
	
func _setup_festival_music_dictionary():
	_festival_music_dictionary_with_bpm["Aerosol"] = 100
	_festival_music_dictionary_with_bpm["Arroz"] = 100
	_festival_music_dictionary_with_bpm["Boogie"] = 100
	_festival_music_dictionary_with_bpm["Neon"] = 100
	_festival_music_dictionary_with_bpm["Newer"] = 100
	_festival_music_dictionary_with_bpm["Energy"] = 100
	_festival_music_dictionary_with_bpm["EnergyFaster"] = 100
	_festival_music_dictionary_with_bpm["Voxel"] = 100
	_festival_music_dictionary_with_bpm["Wave"] = 100


func start_boombox():
	current_music = get_random_festival_music_id()
	AudioManager.instance.play_audio(current_music)
	print("[Festival] Starting music is:", current_music)


func change_boombox_music():
	var new_music_id = _get_different_music()
	if current_music != null:
		AudioManager.instance.fade_out_music(current_music)
		_is_changing_music = true
		var half_fade_timeout = AudioManager.fade_timeout / 2
		await get_tree().create_timer(half_fade_timeout).timeout
		_is_changing_music = false
	AudioManager.instance.fade_in_music(new_music_id)
	current_music = new_music_id
	print("[Festival] New Music is:", current_music)
	
func get_random_festival_music_id() -> String:
	return _festival_music_dictionary_with_bpm.keys().pick_random()


func _get_different_music() -> String:
	var new_music_id = get_random_festival_music_id()
	while new_music_id == current_music:
		new_music_id = get_random_festival_music_id()
	
	return new_music_id


func _set_previous_music():
	if current_music == null:
		return
		
	previous_music = current_music
	

func _on_boom_box_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_mouse_click"):
		if not _is_changing_music:
			change_boombox_music()
		else:
			print("Is still changing music")
