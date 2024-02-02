class_name MovementLookat extends Object

################################################################################
# Description: 
################################################################################

@export var SPEED: float = 200.0
@export var SPEED_ROTATE: float = 1.0

var _node: Node2D
var _target: Node2D

func _init(node: Node2D, target: Node2D) -> void:
	_node = node
	_target = target

func update(delta: float) -> void:
	MathUtil.rotate_to(_node, _target, SPEED_ROTATE, delta)
	_node.global_position += Vector2(1, 0).rotated(_node.rotation) * SPEED * delta



