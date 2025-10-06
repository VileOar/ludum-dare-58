extends Node2D

@export var _game_manager_ref: GameManager

var is_clicked: bool = false
var has_entered: Dictionary[Node2D, bool]

# Audio Assist
@export var min_velocity_to_play_slice_sfx := 1000
@export var sfx_timeout := 0.4
var is_slice_sfx_playable: bool = true


func _on_mook_death(mook : Mook) -> void:
	if mook.get_stats().rarity == Global.Rarities.COMMON:
		AudioManager.instance.play_death_sfx()
	if mook.get_stats().rarity == Global.Rarities.RARE:
		AudioManager.instance.play_death_sfx()
	if mook.get_stats().rarity == Global.Rarities.LEGENDARY:
		AudioManager.instance.play_death_sfx()
		#AudioManager.instance.play_special_death_sfx()
		

func _process(_delta):
	$SlashArea.position = get_global_mouse_position()


func _input(event):
	if event is InputEventMouseButton:
		is_clicked = !is_clicked
		$SlashTrail.is_active = is_clicked
		if not is_clicked:
			has_entered.clear()
			
	if event is InputEventMouseMotion:
		if is_clicked && event.velocity.length() > min_velocity_to_play_slice_sfx:
			if is_slice_sfx_playable:
				_play_slice_sfx()


func _play_slice_sfx() -> void:
	is_slice_sfx_playable = false
	AudioManager.instance.play_random_slice_sfx()
	await get_tree().create_timer(sfx_timeout).timeout
	is_slice_sfx_playable = true
	

func _on_slash_area_body_entered(body: Node2D) -> void:
	if is_clicked:
		has_entered[body] = true


func _on_slash_area_body_exited(body: Node2D) -> void:
	if is_clicked and has_entered.has(body) and has_entered[body]:
		var mook: Mook = body as Mook
		_game_manager_ref.collect_mook(mook)
		_on_mook_death(mook)
		mook.queue_free()
