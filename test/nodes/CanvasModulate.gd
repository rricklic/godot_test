extends CanvasModulate

const PI_HALF: float = PI * 0.5
const PI_DOUBLE: float = PI * 2

@export var gradient: GradientTexture1D
@export var period_time: float = 60.0
var time: float = -PI_HALF

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	time += delta
	var t = lerpf(0, PI_DOUBLE, fmod(time, period_time) / period_time)
	var value = (sin(t) + 1.0) / 2.0
	self.color = gradient.gradient.sample(value)
