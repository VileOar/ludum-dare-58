class_name TransitionOverlay
extends Control

signal fade_out_end
signal fade_in_end

var _gradient: Gradient

func _ready() -> void:
	var gradient_tex: GradientTexture2D = $Overlay.texture
	_gradient = gradient_tex.gradient

func fade_out(duration: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(_set_fill_ratio, 0.0, 1.0, duration)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_callback(fade_out_end.emit)

func fade_in(duration: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(_set_fill_ratio, 1.0, 0.0, duration)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_callback(fade_in_end.emit)

func _set_fill_ratio(fill_ratio: float) -> void:
	var offset = lerpf(0.82, 0.0, fill_ratio)
	_gradient.set_offset(1, offset)
