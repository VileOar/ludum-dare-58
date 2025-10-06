extends Node

const DEATH_VOICES := {
	1: preload("uid://cplkbgo8br366"),
	2: preload("uid://dovyel7pnyhsg"),
	3: preload("uid://cpb0mmsfi4ujk"),
	4: preload("uid://rv1os0ciboej"),
	5: preload("uid://btn0br7tkhena"),
	6: preload("uid://dw8ca23aqrqo2"),
	7: preload("uid://c185qm2gpnku2"),
	8: preload("uid://ptoglwqb22fw"),
	9: preload("uid://bwdnmw44bbgvd"),
	10: preload("uid://bgeitrfj7yll6"),
	11: preload("uid://cfmgo67xffhik"),
	12: preload("uid://b8cyekdugw67y"),
	13: preload("uid://ctw62fqo34p4g"),
	14: preload("uid://ch22137nbvgme"),
	15: preload("uid://bk583rb2yjqux"),
	16: preload("uid://ccfeifokun3nj"),
	17: preload("uid://1fwcef0ln0c6")
}

func _ready() -> void:
	add_all_death_sfx()
	

func add_all_death_sfx():
	for key in range(1, DEATH_VOICES.size()):
		add_sound_player(DEATH_VOICES[key])


func add_sound_player(stream: AudioStream):
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.autoplay = false
	player.volume_db = 10.0
	add_child(player)
