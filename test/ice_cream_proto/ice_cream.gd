class_name IceCream
extends Area2D

const SPEED: float = 100.0
static var colors: Array[Color] = [Color.HOT_PINK, Color.MINT_CREAM, Color.SADDLE_BROWN, Color.TAN]
var color: Color	
var is_falling: bool = true
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@onready var polygon: Polygon2D = $Polygon2D
func _ready() -> void:
	polygon.color = IceCream.colors[rng.randi_range(0, IceCream.colors.size()-1)]
	global_position = Vector2(rng.randi_range(20, 220), -50)
	
func _physics_process(delta: float) -> void:
	if is_falling:
		global_position.y += SPEED * delta
		if global_position.y > 500:
			queue_free()
	
