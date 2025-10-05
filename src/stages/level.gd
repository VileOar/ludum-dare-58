extends Node

@export var _MOOK_PCK: PackedScene

const WAVE_SPEED := Global.BLOCK * 6
const WAVE_MIN_INTERVAL := 10.0
const WAVE_MAX_INTERVAL := 15.0

@onready var _entities: Node2D = $Entities
@onready var _wave_area: Area2D = $WaveArea
@onready var _wave_timer: Timer = $WaveTimer


@export var _spawn_bounds: Rect2
@export var _center_blocked: StaticBody2D

# whether a wave is currently running
var _wave_active = false


# TODO: remove
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if (event as InputEventKey).keycode == KEY_SPACE:
			_spawn_crowd(Global.NUM_SPAWNED_MOOKS)
			$Label.hide()
		elif (event as InputEventKey).keycode == KEY_E:
			_start_wave()


func _physics_process(delta: float) -> void:
	if _wave_active:
		_wave_area.position.x += WAVE_SPEED * delta
		if _wave_area.position.x > _spawn_bounds.end.x:
			_wave_active = false
			_wave_area.monitoring = false


func _spawn_crowd(amount: int):
	for _i in amount:
		var pos = _get_random_spawn_pos()
		
		while _is_spawning_inside_center_space(pos):
			pos = _get_random_spawn_pos()
		
		_spawn_mook(pos)


func _spawn_mook(pos: Vector2):
	var mook = _MOOK_PCK.instantiate() as Mook
	mook.position = pos
	mook.set_stats(MookStats.build_random_stats())
	_entities.add_child(mook)


func _start_wave():
	_wave_active = true
	_wave_area.monitoring = true
	_wave_area.position = Vector2(
			_spawn_bounds.position.x,
			_spawn_bounds.position.y + _spawn_bounds.size.y / 2
	)
	
func _get_random_spawn_pos() -> Vector2:
	return Vector2(
			randf_range(_spawn_bounds.position.x, _spawn_bounds.end.x),
			randf_range(_spawn_bounds.position.y, _spawn_bounds.end.y)
		)
	
	
func _is_spawning_inside_center_space(pos : Vector2) -> bool:
	var shape : Shape2D = _center_blocked.get_node("CollisionShape2D").shape
	if shape == null:
		return false
	
	var shape_center_pos = _center_blocked.global_position
	var half_size = shape.extents
	
	return (
		pos.x > shape_center_pos.x - half_size.x and
		pos.x < shape_center_pos.x + half_size.x and
		pos.y > shape_center_pos.y - half_size.y and
		pos.y < shape_center_pos.y + half_size.y
	)


func _on_wave_area_body_entered(body: Node2D) -> void:
	(body as Mook).do_the_wave()


func _on_wave_timer_timeout() -> void:
	_start_wave()
	_wave_timer.start(randf_range(WAVE_MIN_INTERVAL, WAVE_MAX_INTERVAL))
