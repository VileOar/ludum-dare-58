class_name Hud
extends Control


@onready var bag_slot_icons: Array[TextureRect] = [
	$VBoxContainer/Slot6/TextureRect,
	$VBoxContainer/Slot5/TextureRect,
	$VBoxContainer/Slot4/TextureRect,
	$VBoxContainer/Slot3/TextureRect,
	$VBoxContainer/Slot2/TextureRect,
	$VBoxContainer/Slot1/TextureRect,
]

func _ready() -> void:
	ScoreManager.connect("scored_a_combo", display_combo_pop_up)

func update_bag_slots_display(bag_slots) -> void:
	$BagSlots.text = "%02d" % bag_slots


func update_bag_slot_icons(last_collected_mooks: Array[MookStats]) -> void:
	for i in last_collected_mooks.size():
		bag_slot_icons[i].texture = Global.shape_icons[last_collected_mooks[i].shape]
		bag_slot_icons[i].modulate = Global.colour_values[last_collected_mooks[i].colour]


func display_combo_pop_up(bonus_score: int, _combo: Global.Combos) -> void:
	$Combo.text = "Combo! +" + str(bonus_score)
	$Combo/ComboAnimPlayer.play("combo_pop_up")
	AudioManager.play_audio("ComboPower1")


func update_timer(time) -> void:
	var secs = round(time)
	var msecs = fmod(time, 1) * 1000
	var format_string = "%02d:%03d"
	var time_string = format_string % [secs, msecs]
	$Time.text = time_string
