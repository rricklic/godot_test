extends CharacterBody2D

class_name Player

const SPEED: float = 300.0
const MAX_HP: int = 25
const floating_text_scene: PackedScene = preload("res://scenes/floating_text.tscn")

#@onready var hit_area: Area2D = $HitArea
@onready var life_bar: ValueBar = $ValueBar
@onready var camera: Camera2D = $Camera2D

################################################################################
# Called when node is added to scene tree
# Use to handle:
#   1. property reset
#   2. perfoming immediate logic
# NOTE: Most of the time using _ready is the correct place to put this logic
################################################################################
func _enter_tree() -> void:
	pass

################################################################################
# Only ever called *ONCE* when object first instantiated
# Used to set initial values
################################################################################
func _ready() -> void:
	#self.hit_area.body_entered.connect(self._on_body_entered_hit_area)
	self.life_bar.init(5, 0, MAX_HP)
	self.life_bar.signal_depleted.connect(_die)
	
################################################################################
#
################################################################################
func _input(event: InputEvent) -> void:
	pass

################################################################################
# Called every frame causing the value of delta to not be consistent.
# Priorities speed over consistency; if vsync is enabled may execute fewer times
# than _physics_process().
# NOTE: can create smooth visuals with proper code
################################################################################
func _process(delta: float) -> void:
	pass

################################################################################
# Called 60 times per second
# Use to handle:
#  1. physics
#  2. movement
#  3. custom timers
#  4. various game logic (path finding, updating position)
# NOTE: may result in less than smooth visuals
################################################################################
func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	direction = Input.get_axis("ui_up", "ui_down")
	if direction:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)		

	move_and_slide()

################################################################################
# Called when node is removed from scene tree
# Used to:
#   1. Free memory (like deconstructor) via Node.queue_free() or Object.free()
#   2. Notify other nodes that this node is leaving scene tree
################################################################################
func _exit_tree() -> void:
	self.queue_free()

func _on_body_entered_hit_area(body: Node2D):
	if (body == self):
		return
		
	var damage: int = randi_range(1, 3)
	# TODO: camera "screen shake"

	# TODO: check that body is enemy
	print("PLAYER TAKE DAMAGE")
	
	var hit_text = floating_text_scene.instantiate()
	hit_text.text = str(damage)
	self.add_child(hit_text)
	
	self.life_bar.decrement(damage)

func _die() -> void:
	self.life_bar.visible = false
	self.camera.ignore_rotation = true
	var tween = self.create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation", 8 * PI, 2).from(self.rotation)
	tween.tween_callback(self.queue_free)
