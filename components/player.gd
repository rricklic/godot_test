class_name Player2 extends Node2D

################################################################################
# Description: 
################################################################################

@export var up: String
@export var down: String
@export var left: String
@export var right: String

var movement: MovementConst

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health: Health2 = $Health

func _ready() -> void:
	hurtbox.signal_hurt.connect(_take_damage)
	health.signal_health_change.connect(_check_health)
	movement = MovementConst.new(self)

func _take_damage(hitBox: Hitbox) -> void:
	health.adjust(-hitBox.damage)
	_knockback(hitBox.global_position.direction_to(global_position), hitBox.damage)

# TODO: common function
func _knockback(dir: Vector2, strength: float) -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", global_position + dir * strength * 10, 0.25).from_current()

func _check_health(health: float) -> void:
	print("health = " + str(health))
	if (health <= 0):
		print("DEAD")
	
func _physics_process(delta: float)	-> void:
	movement.update(delta)
