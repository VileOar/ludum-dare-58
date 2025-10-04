extends Node2D

var mat

func _ready():
	mat = load("res://assets/shaders/InlineMaterial.tres")
	mat.set("shader_parameter/screen_resolution", DisplayServer.screen_get_size())

func _process(_delta):
	mat.set("shader_parameter/mouse_position", DisplayServer.mouse_get_position())
