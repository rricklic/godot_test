class_name Player extends CharacterBody2D

@export var player_movement_data: PlayerMovementData

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_dash: bool = false
var can_dash: bool = false


# TODO: consider wall jump timer, similar to coyote jump timer

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_time_timer: Timer = $CoyoteTimeTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var air_jumps_left: int = player_movement_data.max_air_jumps
@onready var starting_position: Vector2 = global_position
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	hurtbox.signal_hurt.connect(_handle_hurt)

func _handle_gravity(delta: float) -> void:
	if (!is_on_floor()): # && coyote_time_timer.time_left <= 0.0 # To walk off floor without falling
		velocity.y += gravity * player_movement_data.gravity_scale * delta

func _handle_jump() -> void:
	if (is_on_floor()):
		air_jumps_left = player_movement_data.max_air_jumps
		can_dash = true
	
	if (Input.is_action_just_pressed("ui_accept")):
		jump_buffer_timer.start()

	if (is_on_floor() || coyote_time_timer.time_left > 0.0):
		if jump_buffer_timer.time_left > 0.0:
			print("Jump")
			is_dash = false
			velocity.y = player_movement_data.jump_velocity
			jump_buffer_timer.stop()

	if (is_on_wall() && jump_buffer_timer.time_left > 0.0):
		print("Jump")
		is_dash = false
		var wall_normal = get_wall_normal()
		animated_sprite_2d.flip_h = wall_normal.x < 0
		velocity.x = player_movement_data.speed * wall_normal.x
		velocity.y = player_movement_data.jump_velocity
		jump_buffer_timer.stop()
	elif (!is_on_floor()):
		if Input.is_action_just_released("ui_accept") && velocity.y < player_movement_data.get_jump_short_velocity():
			velocity.y =  player_movement_data.get_jump_short_velocity()
		if (jump_buffer_timer.time_left > 0.0 && air_jumps_left > 0):
			print("Air Jump")
			is_dash = false
			velocity.y = player_movement_data.get_jump_air_velocity()
			air_jumps_left -= 1


func _handle_movement(direction: float, delta: float) -> void:
	if direction:
		var acceleration: float = player_movement_data.acceleration_ground if is_on_floor() else player_movement_data.acceleration_air
		velocity.x = move_toward(velocity.x, direction * player_movement_data.speed, acceleration * delta)
	else:
		var friction: float = player_movement_data.friction_ground if is_on_floor() else player_movement_data.friction_air
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		
	if (velocity.x < 0):
		animated_sprite_2d.flip_h = true
	elif (velocity.x > 0):
		animated_sprite_2d.flip_h = false

func _handle_hurt(hitbox: Hitbox) -> void:
	# TODO: knockback
	# TODO: decrement health
	# TODO: flash/flicker sprite
	global_position = starting_position
	#queue_free()

func _update_animation(direction: float) -> void:
	if (!is_on_floor()):
		animated_sprite_2d.play("jump")
	else:
		if (direction != 0):
			animated_sprite_2d.play("run")
			animated_sprite_2d.flip_h = direction < 0
		else:
			animated_sprite_2d.play("idle")

func _handle_dash(direction: Vector2) -> void:
	if (!is_dash && can_dash && Input.is_action_just_pressed("player_dash") && direction != Vector2.ZERO):
		print("Dash")
		gpu_particles_2d.emitting = true
		is_dash = true
		can_dash = false
		_handle_dash_trail()
		velocity = direction * player_movement_data.dash_speed
		await get_tree().create_timer(player_movement_data.dash_duration).timeout
		gpu_particles_2d.emitting = false
		is_dash = false
		
func _get_current_sprite() -> Texture2D:
	var index: int = animated_sprite_2d.get_frame()
	var name: String = animated_sprite_2d.animation
	return animated_sprite_2d.sprite_frames.get_frame_texture(name, index)
	
func _handle_dash_trail() -> void:
	var packed_scene: PackedScene = load("res://scenes/6_platformer/ghost_sprite.tscn")
	while is_dash:
		var node: GhostSprite = packed_scene.instantiate() #GhostSprite.new()
		node.global_position = global_position
		node.texture = _get_current_sprite()
		node.flip_h = (velocity.x < 0)
		get_tree().current_scene.add_child.call_deferred(node)
		var timer: SceneTreeTimer = get_tree().create_timer(0.049)
		await timer.timeout

func _physics_process(delta: float) -> void:
	var direction_x: float = Input.get_axis("ui_left", "ui_right")
	var direction_y: float = Input.get_axis("ui_up", "ui_down")
	
	if (!is_dash):
		_handle_gravity(delta)

	_handle_jump()
	_handle_dash(Vector2(direction_x, direction_y))
	
	if (!is_dash):	
		_handle_movement(direction_x, delta)

	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor():
		animation_player.play("jump")
		if (velocity.y >= 0):
			coyote_time_timer.start()
		
	if (!was_on_floor && is_on_floor()):
		animation_player.play("land")
		
	#if (Input.is_action_just_pressed("ui_up")):
	#	player_movement_data = load("res://scenes/6_platformer/player_movement_data_default.tres")
	#if (Input.is_action_just_pressed("ui_down")):
	#	player_movement_data = load("res://scenes/6_platformer/player_movement_data_ice.tres")
		
	_update_animation(direction_x)
	
