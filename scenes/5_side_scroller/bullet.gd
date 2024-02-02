extends Node2D

class_name Bullet

@export var velocity: int = 200
@export var radius: int = 2
@export var color: Color = Color.CYAN
@export var damage: int = 5

@onready var on_screen: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D
@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
func _ready() -> void:
	collision_shape.shape.radius = self.radius
	area.body_entered.connect(_deal_damage)
	on_screen.screen_exited.connect(_free)

func _draw() -> void:
	self.draw_circle(Vector2(0, 0), self.radius, self.color)

func _physics_process(delta: float) -> void:
	self.global_position += Vector2(velocity * delta, 0)

func _deal_damage(body: Node2D) -> void:
	if (body.has_method("take_damage")):
		body.take_damage(self.damage)
		_free()

func _free() -> void:
	self.queue_free()
