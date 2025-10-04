extends Node2D

var materials

func _ready():
	materials = [
		load("res://assets/shaders/red_material.tres"),
		load("res://assets/shaders/orange_material.tres"),
		load("res://assets/shaders/yellow_material.tres"),
		load("res://assets/shaders/green_material.tres"),
		load("res://assets/shaders/blue_material.tres"),
		load("res://assets/shaders/purple_material.tres")
	]
	
	for mat in materials:
		mat.set("shader_parameter/screen_resolution", DisplayServer.screen_get_size())

func _process(_delta):
	for mat in materials:
		mat.set("shader_parameter/mouse_position", DisplayServer.mouse_get_position())
