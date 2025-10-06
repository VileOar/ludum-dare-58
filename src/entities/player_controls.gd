extends Node2D

@export var _game_manager_ref: GameManager

var is_clicked: bool = false
var has_entered: Dictionary[Node2D, bool]


func _on_mook_death(mook : Mook) -> void:
	if mook.get_stats().rarity == Global.Rarities.COMMON:
		AudioManager.instance.play_death_sfx()
	if mook.get_stats().rarity == Global.Rarities.RARE:
		AudioManager.instance.play_special_death_sfx()
	if mook.get_stats().rarity == Global.Rarities.LEGENDARY:
		AudioManager.instance.play_special_death_sfx()
		

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
		var mook: Mook = body as Mook
		_game_manager_ref.collect_mook(mook)
		_on_mook_death(mook)
		mook.queue_free()
