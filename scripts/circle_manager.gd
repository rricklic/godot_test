extends Node2D

class_name CircleManager

const NUM_CIRCLES: int = 10
const DATA_FILE: String = "user://circle.dat"

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var circles: Array = []
var window_size: Vector2 = Vector2(400, 300) # TODO:

@onready var button: Button = get_child(0)
func _ready() -> void:
	rng.randomize()
	button.pressed.connect(_update_circles)
	if (FileAccess.file_exists(DATA_FILE)):
		_load()
	else:
		_add_circles()
	
func _add_circles() -> void:
	for i in NUM_CIRCLES:
		var circle: Circle = _create_circle()
		circle.set_name("Circle_" + str(i))
		circles.push_back(circle)
		self.add_child(circle)

func _create_circle() -> Circle:
	return Circle.new(_create_random_position())

func _update_circles() -> void:
	for circle in circles:
		circle.update_position(_create_random_position())

func _create_random_position() -> Vector2:
	return Vector2(rng.randf_range(0, window_size.x), rng.randf_range(0, window_size.y))

# TODO: Use ResourceSaver	
func _save() -> void:
	var file: FileAccess = FileAccess.open(DATA_FILE, FileAccess.WRITE)
	for circle in circles:
		file.store_float(circle.position.x)
		file.store_float(circle.position.y)
	file.close()

# TODO: Use ResourceSaver	
func _load() -> void:
	var file: FileAccess = FileAccess.open(DATA_FILE, FileAccess.READ)
	var i: int = 0
	while (!file.eof_reached()):
		var circle: Circle = Circle.new(Vector2(file.get_float(), file.get_float()))
		circle.set_name("Circle_" + str(i))
		circles.push_back(circle)
		self.add_child(circle)
		i += 1
	file.close()
	
func _notification(what: int) -> void:
	if (what == NOTIFICATION_WM_CLOSE_REQUEST):
		self._save()
		get_tree().quit() # Default behavior
