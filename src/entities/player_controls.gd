extends Node2D


var is_clicked: bool = false


func _input(event):
	if event is InputEventMouseButton:
		is_clicked = !is_clicked
		$SlashTrail.is_active = is_clicked
	
	if event is InputEventMouseMotion:
		$SlashArea.position = event.position


# killing on enter, maybe kill only when enter and exit while holding mouse btn?
func _on_slash_area_body_entered(body: Node2D) -> void:
	if is_clicked:
		(body as Mook).queue_free()
