extends Node

@export var _MOOK_PCK: PackedScene


@onready var _entities: Node2D = $Entities

@export var _spawn_bounds: Rect2


# TODO: remove
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if (event as InputEventKey).keycode == KEY_SPACE:
			_spawn_crowd(100)


func _spawn_crowd(amount: int):
	for _i in amount:
		var pos = Vector2(
			randf_range(_spawn_bounds.position.x, _spawn_bounds.end.x),
			randf_range(_spawn_bounds.position.y, _spawn_bounds.end.y)
		)
		_spawn_mook(pos)


func _spawn_mook(pos: Vector2):
	var mook = _MOOK_PCK.instantiate()
	mook.position = pos
	# TODO: generate random stats
	
	_entities.add_child(mook)
