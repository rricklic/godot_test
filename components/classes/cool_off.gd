class_name CoolOff
extends Object

var time_cooloff: float
var time_left: float

func _init(time_cooloff: float) -> void:
	self.time_cooloff = time_cooloff

func decrement(delta: float) -> void:
	if (time_left > 0):
		time_left -= delta

func reset() -> void:
	time_left = time_cooloff

func set_ready() -> void:
	time_left = 0.0

func is_ready() -> bool:
	return time_left <= 0.0
