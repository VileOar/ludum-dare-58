extends Control

var _score_string : String = "Score {score}"

func _ready() -> void:
	_update_score_label(_calculate_score(10, 5, 1))

func _calculate_score(commons: int, rares: int, legendaries:int) -> int:
	var score : int = Global.BASE_SCORE * (commons + rares + legendaries)
	score += Global.RARE_BONUS * rares
	score += Global.LEGENDARY_BONUS * legendaries
	return score

func _update_score_label(new_score: int) -> void:
	$Score.text = _score_string.format({"score": new_score})
