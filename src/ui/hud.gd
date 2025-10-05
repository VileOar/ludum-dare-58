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


func update_bag_slots_display(bag_slots) -> void:
	$BagSlots.text = "Bag slots: " + str(bag_slots)


func update_bag_slot_icons(last_collected_mooks: Array[MookStats]) -> void:
	for i in last_collected_mooks.size():
		bag_slot_icons[i].texture = Global.shape_icons[last_collected_mooks[i].shape]
		bag_slot_icons[i].modulate = Global.colour_values[last_collected_mooks[i].colour]
