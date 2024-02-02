class_name MovementConst extends Object

################################################################################
# Description: 
################################################################################

@export var SPEED: float = 200.0

var _node: Node2D

func _init(node: Node2D) -> void:
	_node = node

func update(delta: float) -> void:
	var input_vector: Vector2 = Vector2(
			Input.get_axis("player1_left", "player1_right"),
			Input.get_axis("player1_up", "player1_down"))
	_node.global_position += input_vector * SPEED * delta
