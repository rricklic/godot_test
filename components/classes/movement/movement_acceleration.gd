class_name MovementAcceleration extends Object

################################################################################
# Description: 
################################################################################

#@export var SPEED: float = 200.0
#@export var ACCELERATION: float = 800.0
#@export var FRICTION: float = 600.0

#var _node: CharacterBody2D

#func _init(node: Node2D) -> void:
#	_node = node

static func update(
		node: CharacterBody2D,
		delta: float,
		speed: float = 200.0,
		acceleration: float = 1000.0
	) -> void:
	var input_vector: Vector2 = Vector2(
			Input.get_axis("player1_left", "player1_right"),
			Input.get_axis("player1_up", "player1_down"))	
	input_vector = input_vector.normalized()
	node.velocity.x = move_toward(node.velocity.x, speed * input_vector.x, acceleration * delta)
