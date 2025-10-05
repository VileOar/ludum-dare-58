extends AnimatedSprite2D
class_name BoomBox

@onready var boom_timer: Timer = $BoomTimer

var _interval = 0.0


func press():
	pause()
	play("press")


func set_beat_freq(freq: float):
	boom_timer.stop()
	if freq > 0.0:
		_interval = 0.0
	else:
		_interval = 1.0/freq
		boom_timer.start(_interval)


func _beat():
	boom_timer.stop()
	pause()
	play("boomin")


func _on_boom_timer_timeout() -> void:
	_beat()
	if _interval > 0.0:
		boom_timer.start(_interval)
