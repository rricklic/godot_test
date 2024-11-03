class_name GhostSprite extends Sprite2D

#func _init(sprite: Texture2D, position: Vector2) -> void:
#	self.texture = texture
#	self.global_position = position

func _ready() -> void:
	_ghost()

func _ghost() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.75)
	await tween.finished
	queue_free()
