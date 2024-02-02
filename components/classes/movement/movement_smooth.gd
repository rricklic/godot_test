class_name MovementSmooth extends Object

################################################################################
# Description: 
################################################################################

@export var SPEED: float = 200.0
@export var LERP_WEIGHT: float = 0.05

var _node: CharacterBody2D

func _init(node: Node2D) -> void:
	_node = node

func update(delta: float) -> void:
	var input_vector: Vector2 = Vector2.ZERO
	input_vector.x = Input.get_axis("player1_left", "player1_right")
	input_vector.y = Input.get_axis("player1_up", "player1_down")
	input_vector = input_vector.normalized()
	_node.velocity = lerp(_node.velocity, input_vector * SPEED, LERP_WEIGHT)
	_node.move_and_slide()
