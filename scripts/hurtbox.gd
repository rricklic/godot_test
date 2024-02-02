extends Area2D

class_name HurtBox   

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	self.collision_layer = 0
	self.collision_mask |= 1 << 1

func _ready() -> void:
	self.area_entered.connect(_on_area_entered)
	
func _on_area_entered(hitbox: HitBox2) -> void:
	if (hitbox == null):
		return
	if (owner.has_method("take_damage")):
		owner.take_damage(hitbox.damage);
