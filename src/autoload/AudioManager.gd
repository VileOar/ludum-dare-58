extends Node2D

# Reference to the itself, ensuring only one exists
var instance : Node

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
	
	# Main Menu Music
	add_to_sound_player_dictionary("MainMenuMusic", $MainMenuMusic/Music)
	add_to_sound_player_dictionary("Ambience", $MainMenuMusic/Ambience)
	
	# Festival Music
	add_to_sound_player_dictionary("MusicNumber1", $FestivalMusic/MusicNumber1)
	add_to_sound_player_dictionary("MusicNumber2", $FestivalMusic/MusicNumber2)
	add_to_sound_player_dictionary("MusicNumber3", $FestivalMusic/MusicNumber3)
	add_to_sound_player_dictionary("MusicNumber4", $FestivalMusic/MusicNumber4)
	
	
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


func play_audio_queue(audio_name):
	var audio_queue : AudioQueue = queues_by_name.get(audio_name)	
	if audio_queue != null:
			audio_queue.play_sound()


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
	
	
# UI Audio
func play_click_sfx():
	play_audio("ButtonAccept")
	
func play_hover_sfx():
	play_audio("ButtonHover")
	
func play_decline_sfx():
	play_audio("ButtonNegative")
