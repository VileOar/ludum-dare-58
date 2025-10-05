extends Node2D
class_name StageScene


# audio
var current_music : String

func _ready():
	_start_festival_music()
	pass


#region Audio
func _start_festival_music() -> void:
	#current_music = AudioManager.instance.play_random_festival_music_()
	#print("Current Music = ", current_music)
	pass
	
func _stop_festival_music() -> void:
	AudioManager.instance.stop_audio(current_music)
