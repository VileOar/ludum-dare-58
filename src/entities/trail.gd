extends Line2D


@export var NODE_TO_FOLLOW: Node2D
@export var TRAIL_MAX_LENGTH: int = 20

var trail_queue: Array
var is_active: bool


# trail logic in physics process so that duration is consistent regardless of fps
func _physics_process(_delta):
	var follow_position = NODE_TO_FOLLOW.position
	
	if is_active:
		trail_queue.push_back(follow_position)
	
	if trail_queue.size() > TRAIL_MAX_LENGTH || not is_active:
		trail_queue.pop_front()
	
	clear_points()
	
	for point in trail_queue:
		add_point(point)
