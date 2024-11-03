class_name CircleFollow extends Node2D

const SPEED: float = 5.0
const RADIUS: float = 10.0
const COLOR: Color = Color.AQUA

var prev_mouse_position: Vector2
var scale_factor: float = 0.0
var current_angle: float = 0.0
var base_scale: Vector2

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	prev_mouse_position = get_global_mouse_position()
	base_scale = scale

# Called in sync with frame rate (1/60th second), so delta should be constant
func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	queue_redraw()

func _handle_movement(delta: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	
	# Transfer
	var diff: Vector2 = mouse_position - global_position
	global_position += diff * SPEED * delta
	
	# Stretch / squeeze
	var delta_mouse: Vector2 = mouse_position - prev_mouse_position
	prev_mouse_position = mouse_position
	var mouse_velocity = min(
			sqrt(delta_mouse.x*delta_mouse.x + delta_mouse.y*delta_mouse.y) * 10,
			150.0)
	var scale_value: float = (mouse_velocity / 150.0) * 0.5
	scale_factor += (scale_value - scale_factor) * SPEED * delta
	scale = Vector2(base_scale.x + scale_factor, base_scale.y - scale_factor)
	
	#global_position.x = move_toward(global_position.x, get_global_mouse_position().x, SPEED)
	#global_position.y = move_toward(global_position.y, get_global_mouse_position().y, SPEED)
	
	#rotation_degrees += (current_angle - rotation_degrees) * SPEED * delta
	rotation_degrees = current_angle
	
	if (mouse_velocity > 20):
		current_angle = atan2(delta_mouse.y, delta_mouse.x) * 180 / PI
		print(current_angle)

	
	
func _draw() -> void:
	draw_circle(Vector2.ZERO, RADIUS, COLOR)
	
