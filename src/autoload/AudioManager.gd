extends Node2D

@export var fade_timeout := 2.0

# Reference to the itself, ensuring only one exists
var instance : Node
@onready var _festival_music: Node = $FestivalMusic
@onready var death_sfx: Node = $DeathSFX
var festival_music_name = "FestivalMusic"

# Dictionary to store each SoundPlayer nodes by its name
var _sound_player_by_name : Dictionary = {}
var queues_by_name : Dictionary = {}

#var XXX_is_cooldown = false

func _ready():
	# Store itself to be avaiable in instance. this is used to call functions
	# of the script
	instance = self
	
	# Add the sounds
	add_to_sound_player_dictionary("ButtonAccept", $UI/ButtonAccept)
	add_to_sound_player_dictionary("ButtonDecline", $UI/ButtonDecline)
	add_to_sound_player_dictionary("ButtonHover", $UI/ButtonHover)
	
	# Special Death Sounds
	add_to_sound_player_dictionary("DoneThis", $SpecialDeathSFX/DoneThis)
	
	# Main Menu Music
	add_to_sound_player_dictionary("MainMenuMusic", $MainMenuMusic/Music)
	add_to_sound_player_dictionary("Ambience", $MainMenuMusic/Ambience)
	
	# Slice Audio
	add_to_sound_player_dictionary("ASlice1", $SliceSFX/ASlice1)
	add_to_sound_player_dictionary("ASlice2", $SliceSFX/ASlice2)
	add_to_sound_player_dictionary("ASlice3", $SliceSFX/ASlice3)
	add_to_sound_player_dictionary("ASlice4", $SliceSFX/ASlice4)
	add_to_sound_player_dictionary("ASlice5", $SliceSFX/ASlice5)
	add_to_sound_player_dictionary("ASlice6", $SliceSFX/ASlice6)

	
	# Festival Audio
	add_to_sound_player_dictionary("Scratch", $FestivalSFX/Scratch)
	add_to_sound_player_dictionary("ButtonClick", $FestivalSFX/ButtonClick)
	
	
	# Festival Music
	add_to_sound_player_dictionary("Aerosol", $FestivalMusic/Aerosol)
	add_to_sound_player_dictionary("Arroz", $FestivalMusic/Arroz)
	add_to_sound_player_dictionary("Boogie", $FestivalMusic/Boogie)
	add_to_sound_player_dictionary("Neon", $FestivalMusic/Neon)
	add_to_sound_player_dictionary("Newer", $FestivalMusic/Newer)
	add_to_sound_player_dictionary("Energy", $FestivalMusic/Energy)
	add_to_sound_player_dictionary("EnergyFaster", $FestivalMusic/EnergyFaster)
	add_to_sound_player_dictionary("Voxel", $FestivalMusic/Voxel)
	add_to_sound_player_dictionary("Wave", $FestivalMusic/Wave)
	
	# Death Audio
	add_to_sound_player_dictionary("Death1", $DeathSFX/Death1)
	add_to_sound_player_dictionary("Death2", $DeathSFX/Death2)
	add_to_sound_player_dictionary("Death3", $DeathSFX/Death3)
	add_to_sound_player_dictionary("Death4", $DeathSFX/Death4)
	add_to_sound_player_dictionary("Death5", $DeathSFX/Death5)
	add_to_sound_player_dictionary("Death6", $DeathSFX/Death6)
	add_to_sound_player_dictionary("Death7", $DeathSFX/Death7)
	add_to_sound_player_dictionary("Death8", $DeathSFX/Death8)
	add_to_sound_player_dictionary("Death9", $DeathSFX/Death9)
	add_to_sound_player_dictionary("Death10", $DeathSFX/Death10)
	add_to_sound_player_dictionary("Death11", $DeathSFX/Death11)
	
	
	# Music
	add_to_sound_player_dictionary("EndRound", $Music/EndRound)
	add_to_sound_player_dictionary("Ambiance", $Music/Ambiance)
	add_to_sound_player_dictionary("EndGame", $Music/EndGame)
	add_to_sound_player_dictionary("Arena", $Music/Arena)
	add_to_sound_player_dictionary("Menu", $Music/Menu)

	queues_by_name["shoot"] = $ShootAudioQueue
	
	
func play_audio(audio_name):
	# Get the "audio_name" node if it exists and is an AudioStreamPlayer
	var audio_node = _sound_player_by_name.get(audio_name)
	if audio_node != null:
			audio_node.play()
			
			
func play_audio_random_pitch(audio_name, min_pitch :float, max_pitch :float):
	# Get the "audio_name" node if it exists and is an AudioStreamPlayer
	var audio_node = _sound_player_by_name.get(audio_name)
	if audio_node != null:
		audio_node.pitch_scale = Utils.rng.randf_range(min_pitch, max_pitch)
		audio_node.play()


func play_audio_queue(audio_name):
	var audio_queue : AudioQueue = queues_by_name.get(audio_name)	
	if audio_queue != null:
		audio_queue.play_sound()


func fade_out_music(audio_name):
	var audio_node = _sound_player_by_name.get(audio_name)
	var tween_out : Tween = get_tree().create_tween()
	var _default_volume = audio_node.volume_db
	tween_out.finished.connect(_on_Tween_tween_completed.bind(audio_node, _default_volume))
	# Start at current volume, end at -80dB (silence)
	tween_out.tween_property(audio_node, "volume_db", -80, fade_timeout) 
	tween_out.play()


func fade_in_music(audio_name):
	var audio_node = _sound_player_by_name.get(audio_name)
	var _default_volume = audio_node.volume_db
	#print("$AudioStreamPlayer.volume_db = ", _default_volume)
	var tween : Tween = get_tree().create_tween()
	# Start at -80dB (or lower), end at default audio dB
	tween.tween_property(audio_node, "volume_db", _default_volume, fade_timeout)
	audio_node.play() # Ensure music is playing before starting the fade in
	tween.play()


func _on_Tween_tween_completed(audio_node, _default_volume):
	audio_node.stop()
	audio_node.volume_db = _default_volume # Reset for next fade in


func get_number_of_children_in_festival_music() -> int:
	return _festival_music.get_child_count()


func get_random_festival_music_id() -> String:
	return festival_music_name + str(Utils.rng.randi_range(1, get_number_of_children_in_festival_music()))


#func play_shoot_delay(delay:float):
	#if !shoot_is_cooldown:
		#shoot_is_cooldown = true
		#var audio_queue : AudioQueue = queues_by_name.get("shoot")	
		#if audio_queue != null:
			#audio_queue.play_sound()
			#await get_tree().create_timer(delay).timeout
			#shoot_is_cooldown = false


func stop_audio(audio_name):
	var audio_node = _sound_player_by_name.get(audio_name)
	if audio_node != null:
		audio_node.stop()


func play_audio_Restricted(audio_name):
# Get the "audio_name" node if it exists and is an AudioStreamPlayer
	var audio_node = _sound_player_by_name.get(audio_name)
	
	if audio_node != null:
		# If audio_node exists and is not playing already, play audio
		if !audio_node.is_playing():
			audio_node.play()


func add_to_sound_player_dictionary(node_name, node):
	# Add the node to the sound player dictionary
	# This works as a list with a name to each sound, so you can get it later
	_sound_player_by_name[node_name] = node
	
	
func set_master_volume(volume : float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume))
	
	
# Special Audio
func play_random_slice_sfx():
	var slice_name = "ASlice"
	var slice_number = Utils.rng.randi_range(1, 6)
	var slice_str = str(slice_name, slice_number)
	play_audio(slice_str)

func play_special_death_sfx():
	play_audio_random_pitch("DoneThis", 1.1, 1.5)


func play_death_sfx():
	var death_number = Utils.rng.randi_range(1, death_sfx.get_child_count() - 1)
	var death_str = str("Death", death_number)
	play_audio_random_pitch(death_str, 1.1, 1.3)
	
	
# UI Audio
func play_click_sfx():
	play_audio("ButtonAccept")
	
func play_hover_sfx():
	play_audio("ButtonHover")
	
func play_decline_sfx():
	play_audio("ButtonNegative")
