class_name Health2 extends Node

signal signal_health_change(amount: float)

@export var max_health: float
var health: float

func _ready() -> void:
	health = max_health

func adjust(amount: float) -> void:
	health += amount
	signal_health_change.emit(health)
