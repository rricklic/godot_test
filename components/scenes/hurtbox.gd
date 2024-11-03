class_name Hurtbox extends Area2D

################################################################################
# Description: Identify when HitBox enters this HurtBox and emit signal of the
# event
################################################################################

signal signal_hurt(hitBox: Hitbox)
signal signal_hurt_stop(hitBox: Hitbox)

var hitbox: Hitbox
@export var cooloff_time: float = 1.0

@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D
@onready var hit_timer: Timer = $Timer

func _ready() -> void:
	area_entered.connect(_hitbox_entered)
	area_exited.connect(_hitbox_exited)
	hit_timer.timeout.connect(_emit_hurt)
	hit_timer.one_shot = false

func _hitbox_entered(area2D: Area2D) -> void:
	if (area2D is Hitbox):
		var hitbox: Hitbox = area2D
		self.hitbox = hitbox
		_emit_hurt()
		
func _hitbox_exited(area2D: Area2D) -> void:
	if (area2D is Hitbox):
		var hitbox: Hitbox = area2D
		hit_timer.stop()
		self.hitbox = null
		signal_hurt_stop.emit(hitbox)

func _emit_hurt() -> void:
	signal_hurt.emit(hitbox)
	hit_timer.start(cooloff_time)
