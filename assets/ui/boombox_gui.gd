extends AnimatedSprite2D

@onready var boom_timer: Timer = $BoomTimer
@onready var boom_box_logic: Node2D = $BoomBoxLogic

var _interval = 0.0

func _ready() -> void:
	boom_box_logic.pressed.connect(press)
	#boom_box_logic.new_beat.connect(set_beat_freq)
	boom_box_logic.new_beat.connect(set_beat_freq_with_timer)
	
	
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
	print("set_beat_freq_with_timer")
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


func _on_boom_timer_timeout() -> void:
	_beat()
	if _interval > 0.0:
		boom_timer.start(_interval)
