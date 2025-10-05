extends Control

var _score_string : String = "Score {score}"

func _ready() -> void:
	_update_score_label(3570)

func _update_score_label(new_score: int) -> void:
	$Score.text = _score_string.format({"score": new_score})
