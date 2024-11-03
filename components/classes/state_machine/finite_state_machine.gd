class_name FiniteStateMachine extends Node

@export var state: State

func _ready() -> void:
	_change_state(state)

func _change_state(new_state: State) -> void:
	if (state):
		state._exit_state()
	new_state._enter_state()
	state = new_state
