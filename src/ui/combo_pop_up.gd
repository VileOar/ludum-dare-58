class_name ComboPopUp
extends Label

func pop_up(combo_score) -> void:
	self.set_text("Combo! +" + str(combo_score))
	$ComboAnimPlayer.play("combo_pop_up")

# destroy the label on animation end
func _on_combo_anim_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "combo_pop_up":
		self.queue_free()
