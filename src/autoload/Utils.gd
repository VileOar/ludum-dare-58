extends Node
## This autoload contains useful operations and data independent of project.
##
## Handles math, randomisation and other useful and recurring general situations and data between
## games.[br]
# v1.3 (2024-10-24)

## A global scope RNG.
var rng := RandomNumberGenerator.new():
	set(value):
		push_warning("Forbidden set operation on 'rng'. Ignored.")
	get:
		return rng

# dictionary of physics layers with a set name
var _named_layers: Dictionary


func _ready():
	randomize() # randomise the global-scope random functions
	rng.randomize() # randomise the RNG instance
	
	# initialise layer names dictionary
	for i in range(1, 33):
		var layer_name = ProjectSettings.get_setting("layer_names/2d_physics/layer_" + str(i), "")
		if layer_name != "":
			_named_layers[layer_name] = 1 << (i - 1) # set the value to the corresponding layer value


# ---------------------
# || --- GENERAL --- ||
# ---------------------

## Just a custom failsafe for nullchecks.[br]
## Should be completely unnecessary, since is_instance_valid almost surely checks nulls, but just 
## in case.
func nullcheck(ref: Variant) -> bool:
	return is_instance_valid(ref) and ref != null


## Get a collision bitmask by passing an array of registered layer names.
func get_collision_bitmask(layer_names: Array) -> int:
	if layer_names.is_empty():
		push_warning("No layer names passed. Returning -1.")
		return -1
	
	var mask = 0
	
	for layer in layer_names:
		if _named_layers.has(layer):
			mask |= _named_layers[layer]
	
	return mask


# ------------------
# || --- MATH --- ||
# ------------------

## Return a random 2D position within a radius around a reference position.[br]
## Specify min and max radius and, optionally, a bounds rectangle.[br]
## Positions will stay within bounds rectangle if its size is more than 0.
func random_position2D_around(
		ref_position: Vector2,
		min_radius: float,
		max_radius: float,
		bounds_rect: Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)
):
	var theta: float = randf() * 2 * PI
	var radius: float = randf_range(min_radius, max_radius)
	
	var pos = ref_position + Vector2(cos(theta), sin(theta)) * radius
	
	# if a bounds rect was passed, clamp vector inside bounds
	if bounds_rect.size.length() > 0.0:
		pos = clamp(pos, bounds_rect.position, bounds_rect.end)
	
	return pos
