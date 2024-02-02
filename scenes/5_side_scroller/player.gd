extends CharacterBody2D

@export var speed: int = 100
@export var bullet_cooldown: float = 0.25

const bullet_scene: PackedScene = preload("res://scenes/5_side_scroller/bullet.tscn")

var is_bullet_ready: bool = true

# TODO: keep on screen
# TODO: collide with enemy / queue_free

@onready var timer_bullet_cooldown: Timer = $TimerBulletCooldown
func _ready() -> void:
	self.timer_bullet_cooldown.wait_time = self.bullet_cooldown
	self.timer_bullet_cooldown.timeout.connect(_bullet_ready)

func _physics_process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_A) && is_bullet_ready):
		self._fire_bullet()
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	direction = Input.get_axis("ui_up", "ui_down")
	if direction:
		velocity.y = direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()

func _fire_bullet() -> void:
	self.is_bullet_ready = false
	self.timer_bullet_cooldown.start()
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.global_position = self.global_position;
	get_tree().root.add_child(bullet)
	

func _unhandled_input(event: InputEvent) -> void:
	if (Input.is_key_pressed(KEY_I)):
		print("global_position: " + str(self.global_position))
		print("position: " + str(self.position))
		
func _bullet_ready() -> void:
	self.is_bullet_ready = true
