extends AnimatedSprite2D
class_name BoomBox

@onready var boom_timer: Timer = $BoomTimer

var _interval = 0.0

# Music Control
var previous_music : String
var current_music : String
var _is_changing_music := false
var _festival_music_dictionary_with_bpm : Dictionary = {}
var half_of_fade_timeout :float


func _ready() -> void:
	_setup_festival_music_dictionary()
	half_of_fade_timeout = AudioManager.fade_timeout / 2
	start_boombox()
	
	
func start_boombox():
	current_music = get_random_festival_music_id()
	set_beat_freq(_get_freq_from_music(current_music))
	#set_beat_freq_with_timer(_get_freq_from_music(current_music), _get_time_to_wait_from_music(current_music))
	AudioManager.instance.play_audio(current_music)
	print("[Festival] Starting music is:", current_music)
	
	
func _setup_festival_music_dictionary():
	_festival_music_dictionary_with_bpm["Aerosol"] = {"bpm": 100,"time_to_wait": 0.0 }
	_festival_music_dictionary_with_bpm["Arroz"] = {"bpm": 100,"time_to_wait": 0.0 }
	_festival_music_dictionary_with_bpm["Boogie"] = {"bpm": 89,"time_to_wait": 1.2 }
	_festival_music_dictionary_with_bpm["Neon"] = {"bpm": 80,"time_to_wait": 0.0 }
	_festival_music_dictionary_with_bpm["Newer"] = {"bpm": 110,"time_to_wait": 2.3 }
	_festival_music_dictionary_with_bpm["Energy"] = {"bpm": 122,"time_to_wait": 0.0 }
	_festival_music_dictionary_with_bpm["EnergyFaster"] = {"bpm": 134,"time_to_wait": 0.0 }
	_festival_music_dictionary_with_bpm["Voxel"] = {"bpm": 122,"time_to_wait": 0.1 }
	_festival_music_dictionary_with_bpm["Wave"] = {"bpm": 132,"time_to_wait": 1.2 }


#region UI control
func press():
	pause()
	play("press")

		
func set_beat_freq(freq: float):
	boom_timer.stop()
	if freq > 0.0:
		_interval = 1.0/freq
		boom_timer.start(_interval)
	else:
		_interval = 0.0
		
func set_beat_freq_with_timer(freq: float, time_to_wait :float):
	boom_timer.stop()
	if freq > 0.0:
		_interval = 1.0/freq
		await get_tree().create_timer(time_to_wait).timeout
		boom_timer.start(_interval)
	else:
		_interval = 0.0


func _beat():
	boom_timer.stop()
	pause()
	play("boomin")

#endregion


func change_boombox_music():
	var new_music_id = _get_different_music()
	if current_music != null:
		AudioManager.instance.fade_out_music(current_music)
		_is_changing_music = true
		await get_tree().create_timer(half_of_fade_timeout).timeout
		_is_changing_music = false
	AudioManager.instance.fade_in_music(new_music_id)
	current_music = new_music_id
	await get_tree().create_timer(AudioManager.fade_timeout).timeout
	set_beat_freq(_get_freq_from_music(current_music))
	#set_beat_freq_with_timer(_get_freq_from_music(current_music), _get_time_to_wait_from_music(current_music))
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

func _get_beat_freq(BPM : int) -> float:
	return	BPM / 60.0;
	
func _get_freq_from_music(_current_music : String) -> float:
	print(_current_music, " freq= ", _get_beat_freq(_festival_music_dictionary_with_bpm.get(_current_music).get("bpm")))
	return _get_beat_freq(_festival_music_dictionary_with_bpm.get(_current_music).get("bpm"))
	
func _get_time_to_wait_from_music(_current_music : String) -> float:
	print(_current_music, " time to wait= ", _get_beat_freq(_festival_music_dictionary_with_bpm.get(_current_music).get("time_to_wait")))
	return _get_beat_freq(_festival_music_dictionary_with_bpm.get(_current_music).get("time_to_wait"))

func _on_boom_box_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_mouse_click"):
		if not _is_changing_music:
			press()
			change_boombox_music()


func _on_boom_timer_timeout() -> void:
	print("_on_boom_timer_timeout")
	_beat()
	if _interval > 0.0:
		boom_timer.start(_interval)
