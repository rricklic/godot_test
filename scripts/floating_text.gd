extends Marker2D

class_name FloatingText

var text: String

@onready var label: Label = $Label
func _ready() -> void:
	self.label.text = self.text
	var tween = self.create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(self, "position", Vector2(self.position.x, self.position.y - 25), 2).from(self.position)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 2).from(Vector2(0.5, 0.5))
	tween.tween_property(self, "modulate", Color(1, 0, 0, 0), 2).from(Color(1, 0, 0, 1))
	tween.set_parallel(false)
	tween.tween_callback(_cleanup)	

func _cleanup() -> void:
	queue_free()
