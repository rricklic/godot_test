extends ParallaxBackground

@export var scroll_velocity: int = -100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	self.scroll_base_offset += Vector2(scroll_velocity * delta, 0)
