extends Node2D

@export var game_manager: GameManager
@onready var _night_shade: ColorRect = %NightShade


func _ready():
	game_manager.end_game.connect(set_all_mouse_materials_to_fullscreen)

	
	var mat_array := Global.get_all_materials()
	mat_array.append(_night_shade.material)
	mat_array.append_array(Global.get_all_aura_materials())

	for mat in mat_array:
		mat.set("shader_parameter/screen_resolution", get_viewport().get_visible_rect().size)
		mat.set("shader_parameter/circle_radius", Global.MOUSE_CIRCLE_RADIUS)
		mat.set("shader_parameter/circle_smooth_width", Global.MOUSE_CIRCLE_SMOOTH_WIDTH)


func _input(event):
	if event is InputEventMouseMotion and !Global.get_is_input_blocked():
		_night_shade.material.set("shader_parameter/mouse_position", event.position)
		for mat in Global.get_all_aura_materials():
			mat.set("shader_parameter/mouse_position", event.position)
		for mat in Global.get_all_materials():
			mat.set("shader_parameter/mouse_position", event.position)
			
			
func set_all_mouse_materials_to_fullscreen() -> void:
	print("reseting all materials")
	var mat_array := Global.get_all_materials()
	mat_array.append(_night_shade.material)
	mat_array.append_array(Global.get_all_aura_materials())
	
	for mat in mat_array:
		mat.set("shader_parameter/screen_resolution", get_viewport().get_visible_rect().size)
		mat.set("shader_parameter/circle_radius", get_viewport().get_visible_rect().size[0])
		mat.set("shader_parameter/circle_smooth_width", 0.0)
