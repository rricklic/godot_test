extends CharacterBody2D

@export var SPEED: float = 200.0
@export var JUMP_HEIGHT: float = 100.0
@export var JUMP_TIME_PEAK: float = 0.5
@export var JUMP_TIME_LAND: float = 0.4
@export var COYOTE_TIME: float = 0.5

@onready var _jump_velocity: float = (2.0 * JUMP_HEIGHT) / JUMP_TIME_PEAK * -1.0
@onready var _jump_gravity: float = -(2.0 * JUMP_HEIGHT) / (JUMP_TIME_PEAK * JUMP_TIME_PEAK) * -1.0
@onready var _fall_gravity: float = -(2.0 * JUMP_HEIGHT) / (JUMP_TIME_LAND * JUMP_TIME_LAND) * -1.0

func _get_gravity() -> float:
	return _jump_gravity if (velocity.y < 0.0) else _fall_gravity


func coyote_time() -> void:
	var was_on_floor: bool = false
	var coyote_time_timer: Timer

	if (!coyote_time_timer.is_stopped() && is_on_floor()):
		coyote_time_timer.stop()
	if (was_on_floor && !is_on_floor() && velocity.y >= 0):
		coyote_time_timer.start(COYOTE_TIME)
		

func _physics_process(delta: float) -> void:
	MovementAcceleration.update(self, delta)
	
	var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)	
	
	if (!is_on_floor()):
		# TODO: check that direction is pressing into wall
		if (is_on_wall() && direction < 0 && velocity.y >= 0):
			velocity.y = 100
		else:
			velocity.y += _get_gravity() * delta

	if (Input.is_action_just_pressed("ui_accept") && (is_on_floor() || is_on_wall())):
		velocity.y = _jump_velocity



	move_and_slide()
