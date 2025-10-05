extends Node2D


var is_clicked: bool = false
var has_entered: Dictionary[Node2D, bool]


func _process(_delta):
	$SlashArea.position = get_global_mouse_position()


func _input(event):
	if event is InputEventMouseButton:
		is_clicked = !is_clicked
		$SlashTrail.is_active = is_clicked
		if not is_clicked:
			has_entered.clear()


func _on_slash_area_body_entered(body: Node2D) -> void:
	if is_clicked:
		has_entered[body] = true


func _on_slash_area_body_exited(body: Node2D) -> void:
	if is_clicked and has_entered.has(body) and has_entered[body]:
		(body as Mook).queue_free()
