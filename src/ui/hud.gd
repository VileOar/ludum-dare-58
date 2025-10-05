class_name Hud
extends Control

func update_bag_slots_display(bag_slots) -> void:
	$BagSlots.text = "Bag slots: " + str(bag_slots)
