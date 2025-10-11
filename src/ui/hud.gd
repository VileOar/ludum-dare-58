class_name Hud
extends Control

var _combos_to_display: int = 0

var _time_between_simultaneous_combos: float = 0.3

var _combo_pop_up_scene: PackedScene = load("uid://ceama6gx1r14u")

@onready var bag_slot_icons: Array[TextureRect] = [
	$VBoxContainer/Slot6/TextureRect,
	$VBoxContainer/Slot5/TextureRect,
	$VBoxContainer/Slot4/TextureRect,
	$VBoxContainer/Slot3/TextureRect,
	$VBoxContainer/Slot2/TextureRect,
	$VBoxContainer/Slot1/TextureRect,
]

func _ready() -> void:
	ScoreManager.connect("scored_a_combo", _add_combo_to_display)

func update_bag_slots_display(bag_slots) -> void:
	$BagSlots.text = "%02d" % bag_slots


func update_bag_slot_icons(last_collected_mooks: Array[MookStats]) -> void:
	for i in last_collected_mooks.size():
		bag_slot_icons[i].texture = Global.shape_icons[last_collected_mooks[i].shape]
		bag_slot_icons[i].modulate = Global.colour_values[last_collected_mooks[i].colour]

func _add_combo_to_display(bonus_score: int, _combo: Global.Combos) -> void:
	_combos_to_display += 1
	if _combos_to_display == 1:
		display_combo_pop_up(bonus_score)
		await get_tree().create_timer(_time_between_simultaneous_combos).timeout
		_combos_to_display -= 1
	else:
		await get_tree().create_timer(_time_between_simultaneous_combos * _combos_to_display).timeout
		_combos_to_display -= 1
		display_combo_pop_up(bonus_score)

func display_combo_pop_up(bonus_score: int) -> void:
	var combo_pop_up: ComboPopUp = _combo_pop_up_scene.instantiate()
	$ComboPopUpSpawner.add_child(combo_pop_up)
	combo_pop_up.pop_up(bonus_score)
	AudioManager.play_audio("ComboPower1")


func update_timer(time) -> void:
	var secs = round(time)
	var msecs = fmod(time, 1) * 1000
	var format_string = "%02d:%03d"
	var time_string = format_string % [secs, msecs]
	$Time.text = time_string
