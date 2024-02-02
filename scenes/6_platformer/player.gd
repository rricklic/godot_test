extends CharacterBody2D

@export var player_movement_data: PlayerMovementData

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_time_timer: Timer = $CoyoteTimeTimer
@onready var jump_button_timer: Timer = $JumpButtonTimer
@onready var air_jumps_left: int = player_movement_data.max_air_jumps

func _handle_gravity(delta: float) -> void:
	if (!is_on_floor()): # && coyote_time_timer.time_left <= 0.0 # To walk off floor without falling
		velocity.y += gravity * player_movement_data.gravity_scale * delta

func _handle_jump() -> void:
	if (is_on_floor()):
		air_jumps_left = player_movement_data.max_air_jumps
	
	if (Input.is_action_just_pressed("ui_accept")):
		jump_button_timer.start()

	if (is_on_floor() || coyote_time_timer.time_left > 0.0):
		if jump_button_timer.time_left > 0.0:
			velocity.y = player_movement_data.jump_velocity
			jump_button_timer.stop()

	if (!is_on_floor()):
		if Input.is_action_just_released("ui_accept") && velocity.y < player_movement_data.get_jump_short_velocity():
			velocity.y =  player_movement_data.get_jump_short_velocity()
		if (jump_button_timer.time_left > 0.0 && air_jumps_left > 0):
			velocity.y = player_movement_data.get_jump_air_velocity()
			air_jumps_left -= 1
			
	if (is_on_wall() && jump_button_timer.time_left > 0.0):
		var wall_normal = get_wall_normal()
		animated_sprite_2d.flip_h = wall_normal.x < 0
		velocity.x = player_movement_data.speed * wall_normal.x
		velocity.y = player_movement_data.jump_velocity
		jump_button_timer.stop()

func _handle_movement(direction: float, delta: float) -> void:
	if direction:
		var acceleration: float = player_movement_data.acceleration_ground if is_on_floor() else player_movement_data.acceleration_air
		velocity.x = move_toward(velocity.x, direction * player_movement_data.speed, acceleration * delta)
	else:
		var friction: float = player_movement_data.friction_ground if is_on_floor() else player_movement_data.friction_air
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func _update_animation(direction: float) -> void:
	if (!is_on_floor()):
		animated_sprite_2d.play("jump")
	else:
		if (direction != 0):
			animated_sprite_2d.play("run")
			animated_sprite_2d.flip_h = direction < 0
		else:
			animated_sprite_2d.play("idle")

func _physics_process(delta: float) -> void:
	_handle_gravity(delta)
	_handle_jump()
	var direction: float = Input.get_axis("ui_left", "ui_right")
	_handle_movement(direction, delta)
	_update_animation(direction)

	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor() && velocity.y >= 0:
		coyote_time_timer.start()
		
	if (Input.is_action_just_pressed("ui_up")):
		player_movement_data = load("res://scenes/6_platformer/player_movement_data_default.tres")
	if (Input.is_action_just_pressed("ui_down")):
		player_movement_data = load("res://scenes/6_platformer/player_movement_data_ice.tres")
