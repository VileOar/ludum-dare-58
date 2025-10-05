extends Node2D


func _ready():
	for mat in Global.get_all_materials():
		mat.set("shader_parameter/screen_resolution", DisplayServer.screen_get_size())
		mat.set("shader_parameter/circle_radius", Global.MOUSE_CIRCLE_RADIUS)
		mat.set("shader_parameter/circle_smooth_width", Global.MOUSE_CIRCLE_SMOOTH_WIDTH)


func _process(_delta):
	for mat in Global.get_all_materials():
		mat.set("shader_parameter/mouse_position", DisplayServer.mouse_get_position())
