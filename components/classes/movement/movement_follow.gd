class_name MovementFollow extends Object

################################################################################
# Description: 
################################################################################

@export var SPEED: float = 200.0

var _node: Node2D
var _target: Node2D

func _init(node: Node2D, target: Node2D) -> void:
	_node = node
	_target = target

func update(delta: float) -> void:
	_node.global_position = _node.global_position.move_toward(_target.global_position, SPEED * delta)
