class_name MovementCurve extends Object

################################################################################
# Description: 
################################################################################

@export var CURVE_ACCELERATION: Curve # TODO: if input to move
@export var CURVE_DECELERATION: Curve # TODO: if no input to move

var _node: CharacterBody2D
var _duration: float = 0.0

func _init(node: Node2D) -> void:
	_node = node

func reset() -> void:
	_duration = 0.0

func update_accelerate(delta: float) -> void:
	_update(CURVE_ACCELERATION, delta)

func update_decelerate(delta: float) -> void:
	_update(CURVE_DECELERATION, delta)

func _update(curve: Curve, delta: float) -> void:
	_duration += delta
	_node.velocity.x = curve.sample(_duration) # TODO: must _duration be clamped(0.0, Curve.max_value)?
	_node.move_and_slide()
