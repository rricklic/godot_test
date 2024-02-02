extends Node2D

@export var health: int = 10
@export var velocity = -50

var time: float = 0.0
var movement: String = "sin"
var y_start: float = 0.0
# TODO: enemy motion: stright line, sin wave, large square wave, towards player, shoot 'n evade
# TODO: enemy bullets

func _ready() -> void:
	self.y_start = self.global_position.y

func _physics_process(delta: float) -> void:
	self.time += delta
	self.global_position.x += self.velocity * delta
	self.global_position.y = y_start # + sin(self.time*10.0) * 10.0 # TODO: for sin wave

func take_damage(damage: int):
	self.health -= damage
	print("TAKE DAMAGE " + str(self.health))
	if (self.health <= 0):
		self.queue_free()
