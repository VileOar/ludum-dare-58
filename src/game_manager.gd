class_name GameManager
extends Node2D

@export var _score_screen: PackedScene
@export var _hud_ref: Hud
@export var _score_manager_ref: ScoreManager

var _bag_slots_remaining: int = 50

func _ready() -> void:
	# initialize hud
	_hud_ref.update_bag_slots_display(_bag_slots_remaining)

func remove_bag_slot() -> void:
	if _bag_slots_remaining > 0:
		_bag_slots_remaining -= 1
		_hud_ref.update_bag_slots_display(_bag_slots_remaining)
		if _bag_slots_remaining == 0:
			_end_game()

func collect_mook(mook: Mook) -> void:
	_score_manager_ref.on_collect(mook.get_stats())
	_hud_ref.update_bag_slot_icons(_score_manager_ref._last_collected_mooks)
	remove_bag_slot()

func _end_game() -> void:
	var change_scene := func():
		get_tree().change_scene_to_packed(_score_screen)
	change_scene.call_deferred()
