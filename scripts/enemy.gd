extends CharacterBody2D

class_name Enemy

@export var speed: float = 100.0
@export_range(0, 2 * PI) var rotate_speed: float = (PI * 1 / 180)
var chase_target: Node2D = null
var life: int = 20
@export var is_rotate_to: bool = false
@onready var detection_area: Area2D = $DetectionArea
#@onready var hit_area: Area2D = $HitArea
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	self.detection_area.body_entered.connect(self._on_body_entered_detection_area)
	self.detection_area.body_exited.connect(self._on_body_exited_detection_area)
	#self.hit_area.body_entered.connect(self._on_body_entered_hit_area)

func _physics_process(delta: float):
	if (chase_target != null):
		if (self.is_rotate_to):
			MathUtil.rotate_to(self, chase_target, 1.0, delta)
			self.global_position += Vector2(1, 0).rotated(self.rotation) * self.speed * delta
		else:
			self.global_position = self.global_position.move_toward(chase_target.global_position, self.speed * delta)
	
func _on_body_entered_detection_area(body: Node2D) -> void:
	self.chase_target = body
	
func _on_body_exited_detection_area(body: Node2D) -> void:
	self.chase_target = null

func _on_body_entered_hit_area(body: Node2D):
	if (body == self):
		return
	print("ENEMY TAKE DAMAGE")
	# TODO: check that body is player
	self.queue_free()
	
func take_damage(damage: int) -> void:
	print("Enemy.take_damage")
	animation_player.play("hit")
	life -= damage
	if (life < 0):
		self.queue_free()
