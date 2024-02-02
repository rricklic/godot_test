class_name MovementJump extends Object

################################################################################
# Description: 
# Making a Jump You Can Actually Use - https://www.youtube.com/watch?v=IOe1aGY6hXA&t=25s
# Building a Better Jump GDC - https://www.youtube.com/watch?v=hG9SzQxaCm8&t=801s
################################################################################

@export var JUMP_HEIGHT: float = 100.0
@export var JUMP_TIME_PEAK: float = 0.5
@export var JUMP_TIME_LAND: float = 0.4

var _jump_velocity: float = (2.0 * JUMP_HEIGHT) / JUMP_TIME_PEAK * -1.0
var _jump_gravity: float = -(2.0 * JUMP_HEIGHT) / (JUMP_TIME_PEAK * JUMP_TIME_PEAK) * -1.0
var _fall_gravity: float = -(2.0 * JUMP_HEIGHT) / (JUMP_TIME_LAND * JUMP_TIME_LAND) * -1.0

var _node: CharacterBody2D

func _init(node: Node2D) -> void:
	_node = node

func _get_gravity() -> float:
	return _jump_gravity if (_node.velocity.y < 0.0) else _fall_gravity

func update(delta: float) -> void:
	var input_vector: Vector2 = Vector2.ZERO
	input_vector.y += _get_gravity() * delta
	
	# TODO: separate function to jump vs apply gravity
	if (Input.is_key_pressed(KEY_SPACE)):
		input_vector.y = _jump_velocity
	
	_node.velocity = input_vector
	_node.move_and_slide()
