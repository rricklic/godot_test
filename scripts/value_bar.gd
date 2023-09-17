extends Marker2D

class_name ValueBar

# Emitted when progress_bar.value <= progress_bar.min_value
signal signal_depleted

@onready var progress_bar: ProgressBar = $ProgressBar

func init(value: int, min_value: int, max_value: int) -> void:
	assert(min_value <= max_value)
	assert(min_value <= value && value <= max_value)
	self.progress_bar.value = value
	self.progress_bar.min_value = min_value
	self.progress_bar.max_value = max_value

func decrement(amount: int) -> void:
	assert(amount >= 0)

	var tween = self.create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self.progress_bar, "value", self.progress_bar.value - amount, 0.5).from(self.progress_bar.value)
	tween.tween_callback(_check_value)	

func increment(amount: int) -> void:
	assert(amount >= 0)
	self.progress_bar.value += amount

func get_value() -> int:
	return self.progress_bar.value
	
func _check_value()	 -> void:
	if (self.progress_bar.value <= self.progress_bar.min_value):
		signal_depleted.emit()
