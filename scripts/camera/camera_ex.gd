extends Camera2D

const MAX_X: int = 150
const MAX_Y: int = 150
const MAX_R: int = 45

@export var noise: FastNoiseLite # TODO: allow randomness or noise
var trauma: float = 0.0 # TODO: set according to event
var time: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (self.trauma == 0):
		return
	
	time += delta
	var shake_factor = pow(self.trauma, 2)
	self.offset.x = noise.get_noise_3d(time * 100, 0, 0) * MAX_X * shake_factor
	self.offset.y = noise.get_noise_3d(0, time * 100, 0) * MAX_Y * shake_factor
	self.rotation_degrees = noise.get_noise_3d(0, 0, time * 100) * MAX_R * shake_factor
	
	self.trauma = max(self.trauma - delta, 0)
	
