extends CharacterBody2D
class_name Cone2 

var speed: float = 200.0
var mouse_position: Vector2
var ice_cream: Array[Color]
var screen_size: Vector2
var ice_cream_count: int = 0

@onready var collision_area: CollisionShape2D = $CollisionShape2D
func _ready() -> void:
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	mouse_position = get_global_mouse_position()
	var distance: Vector2 = abs(mouse_position - position)
	if (distance.x < 1):
		velocity.x = 0
	else :
		var direction: Vector2 = (mouse_position - position).normalized()
		velocity.x = direction.x * speed
	rotation_degrees = 30.0 * (velocity.x / speed)
	move_and_slide()
	global_position.x = clamp(global_position.x, 0, screen_size.x)
	
func add_ice_cream() -> void:
	pass
