extends AnimatedSprite2D
class_name DeadMook

const INI_VELOCITY := Vector2.UP * 20.0 * Global.BLOCK
const GRAVITY := Vector2.DOWN * 0.8 * Global.BLOCK

var velocity := INI_VELOCITY


func _physics_process(delta: float) -> void:
	position += velocity * delta
	velocity += GRAVITY


func setup_dead(shape: Global.Shapes, colour: Global.Colours, ref_scale: Vector2):
	scale = ref_scale
	modulate = Global.colour_values[colour]
	match shape:
		Global.Shapes.POINTY:
			play("pointy")
		Global.Shapes.BLOCKY:
			play("blocky")
		Global.Shapes.CHUBBY:
			play("chubby")
		Global.Shapes.STUBBY:
			play("stubby")


func _on_timer_timeout() -> void:
	queue_free()
