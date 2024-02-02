extends Area2D

class_name HitBox2

@export var damage: int = 10

func _init() -> void:
	self.collision_layer |= 1 << 1
	self.collision_mask = 0
