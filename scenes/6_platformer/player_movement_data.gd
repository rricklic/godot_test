class_name PlayerMovementData extends Resource

################################################################################
# Description: 
################################################################################

@export var speed: float = 100.0
@export var acceleration_ground: float = 800.0
@export var acceleration_air: float = 400.0
@export var friction_ground: float = 1000.0
@export var friction_air: float = 200.0
@export var jump_velocity: float = -300.0
@export var jump_short_scale: float = 0.3333
@export var jump_air_scale: float = 0.8
@export var max_air_jumps: int = 1
@export var gravity_scale: float = 1.0

func get_jump_short_velocity() -> float:
	return jump_velocity * jump_short_scale
	
func get_jump_air_velocity() -> float:
	return jump_velocity * jump_air_scale
