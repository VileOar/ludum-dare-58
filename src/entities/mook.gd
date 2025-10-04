extends CharacterBody2D
class_name Mook

const WANDER_SPEED := Global.BLOCK * 0.5
const PANIC_SPEED := Global.BLOCK * 2.0

const IDLE_MIN_DUR := 3.0
const IDLE_MAX_DUR := 10.0
const WANDER_MIN_DUR := 1.0
const WANDER_MAX_DUR := 5.0

const PANIC_MIN_DUR := 3.0
const PANIC_MAX_DUR := 7.0

# if mouse position is closer than this value (squared) and entity is panicable, enters panic state
const MOUSE_DIST_PANIC_THRESHOLD := pow(Global.BLOCK * 2.0, 2)

# chance for becoming panicked when another panicked entity enters vicinity
const PANIC_INFECTION_CHANCE := 0.1

enum States {
	IDLE,
	WANDER,
	ANIM,
	PANIC
}

@onready var _proximity_detector: Area2D = $ProximityDetector
@onready var _state_change_timer: Timer = $StateChangeTimer

# dict of states and update methods
var _state_updates: Dictionary[States, Callable] = {
	States.IDLE: _state_idle,
	States.WANDER: _state_wander,
	States.PANIC: _state_panic,
	States.ANIM: _state_none,
}

var _stats: MookStats

# --- || Aux || ---

# current state
var _state: States = States.IDLE

# flag to identity whether state was initialised, cuz screw init functions
var _dirty_state: bool = true

# direction vector of movement
var _mov_dir := Vector2.ZERO


func _physics_process(delta: float) -> void:
	if _is_panicable() and !is_panic():
		var mouse_dist = get_global_mouse_position().distance_squared_to(global_position)
		if mouse_dist < MOUSE_DIST_PANIC_THRESHOLD:
			_change_state(States.PANIC)
	
	if _state_updates.has(_state):
		_state_updates[_state].call(delta)


func set_stats(new_stats: MookStats):
	_stats = new_stats


# whether this entity is in panic state
func is_panic() -> bool:
	return _state == States.PANIC


# whether this entity can get out of panic state and enters panic state with mouse
func _is_panicable() -> bool:
	return !_stats.is_common()


func _move_and_bounce(speed: float, delta: float):
	var collision = move_and_collide(_mov_dir.normalized() * speed * delta)
	
	if collision:
		_mov_dir = _mov_dir.bounce(collision.get_normal())


func _change_state(new_state: States):
	_state = new_state
	_dirty_state = true


func _is_crowded() -> bool:
	return !_proximity_detector.get_overlapping_bodies().is_empty()


# --- || State update methods || ---

# empty state
func _state_none(_delta: float):
	pass


func _state_idle(_delta: float):
	if _dirty_state:
		_state_change_timer.start(randf_range(IDLE_MIN_DUR, IDLE_MAX_DUR))
		_mov_dir = Vector2.ZERO
		_dirty_state = false
	
	if _state_change_timer.is_stopped():
		var wander_or_anim = randf() > 0.5
		if _is_crowded() or wander_or_anim:
			_change_state(States.WANDER)
		else:
			_change_state(States.ANIM)


func _state_wander(delta: float):
	if _dirty_state:
		_state_change_timer.start(randf_range(WANDER_MIN_DUR, WANDER_MAX_DUR))
		_mov_dir = Vector2.from_angle(randf_range(0, 2*PI))
		_dirty_state = false
	
	_move_and_bounce(WANDER_SPEED, delta)
	
	if _state_change_timer.is_stopped():
		_change_state(States.IDLE)


func _state_panic(delta: float):
	if _dirty_state:
		_state_change_timer.start(randf_range(PANIC_MIN_DUR, PANIC_MAX_DUR))
		_mov_dir = Vector2.from_angle(randf_range(0, 2*PI))
		_dirty_state = false
	
	_move_and_bounce(PANIC_SPEED, delta)
	
	# will only get out of panic state if it is not panicable (became panicked by infection)
	if _state_change_timer.is_stopped() and !_is_panicable():
		_change_state(States.IDLE)
