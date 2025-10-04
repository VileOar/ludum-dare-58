extends Node2D
class_name CustomCamera

@export var stage_scene: StageScene
@export var pan_speed = 10
@export var _tilemap: TileMapLayer

var cam_move_direction = Vector2.ZERO
var screen_size

## total area in pixels of map, that cam can move in
var _total_area: Rect2

@onready var cam_anchor: Node2D = %CameraAnchor
@onready var cam: Camera2D = %MainCamera

func _verify_exported_variables() -> void:
	#if stage_scene == null:
		#print("[Error] Stage_Scene not set in camera controller (not assigned in the Inspector")
		
	if _tilemap == null:
		print("[Error] _tilemap not set in camera controller (not assigned in the Inspector")


func _ready():
	screen_size = get_viewport().get_visible_rect().size
	
	_verify_exported_variables()
	
	_total_area = _tilemap.get_used_rect() as Rect2
	var cellsize = (_tilemap.tile_set.tile_size as Vector2) * _tilemap.scale
	_total_area.position *= cellsize
	_total_area.size *= cellsize # at this point, total area is equal to the full area in pixels of the map
	
	# half screen size margin on top and left
	_total_area.position += screen_size / 2
	# half screen size margin on bottom and right (do NOT divide by 2,
	# because end was shifted by half screen size after previous line of code, so must compensate)
	_total_area.end -= screen_size
	
#	Centers camera in the middle of tilemap
	var center_of_tilemap = _total_area.position + (_total_area.size / 2)
	_set_cam_position(center_of_tilemap)
	
	

func _physics_process(_delta: float) -> void:

	cam_move_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	var mov_dir = cam_move_direction.normalized() * pan_speed
	cam_anchor.position.x = clamp(cam_anchor.position.x + mov_dir.x, _total_area.position.x, _total_area.end.x)
	cam_anchor.position.y = clamp(cam_anchor.position.y + mov_dir.y, _total_area.position.y, _total_area.end.y)
#	TODO can be applied an factor to smooth transition ex: /10
	_set_cam_position(Vector2(cam_anchor.position.x, cam_anchor.position.y))


func _set_cam_position(new_position : Vector2) -> void:
	cam_anchor.position = new_position
	#stage_scene.set_cam_position(new_position)
