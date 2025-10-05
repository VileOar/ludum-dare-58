extends Line2D


@export var TRAIL_MAX_LENGTH: int = 20

var trail_queue: Array
var is_active: bool


func _physics_process(_delta):
	var mouse_position = get_viewport().get_mouse_position()
	
	if is_active:
		trail_queue.push_back(mouse_position)
	
	if trail_queue.size() > TRAIL_MAX_LENGTH || not is_active:
		trail_queue.pop_front()
	
	clear_points()
	
	for point in trail_queue:
		add_point(point)
