extends Node2D

@onready var _night_shade: ColorRect = %NightShade


func _ready():
	var mat_array := Global.get_all_materials()
	mat_array.append(_night_shade.material)
	mat_array.append_array(Global.get_all_aura_materials())

	for mat in mat_array:
		mat.set("shader_parameter/screen_resolution", get_viewport().get_visible_rect().size)
		mat.set("shader_parameter/circle_radius", Global.MOUSE_CIRCLE_RADIUS)
		mat.set("shader_parameter/circle_smooth_width", Global.MOUSE_CIRCLE_SMOOTH_WIDTH)


func _input(event):
	if event is InputEventMouseMotion:
		_night_shade.material.set("shader_parameter/mouse_position", event.position)
		for mat in Global.get_all_aura_materials():
			mat.set("shader_parameter/mouse_position", event.position)
		for mat in Global.get_all_materials():
			mat.set("shader_parameter/mouse_position", event.position)
