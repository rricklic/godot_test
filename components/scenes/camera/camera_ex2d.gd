class_name CameraEx2D extends Area2D

################################################################################
# Description: 
#   Features:
#     debug movement, zoom, rotation
#     screen shake
#     follow single target (TODO: snap to, smoothing (how to with code)) 
#     TODO: look ahead/behind
#     multiple targets
################################################################################

signal signal_add_camera_target(node2D: Node2D)
signal signal_remove_camera_target(node2D: Node2D)
signal signal_set_camera_target(node2D: Node2D)
signal signal_clear_camera_targets(node2D: Node2D)

@export var noise: FastNoiseLite
@export var noise_speed: float = 1.0

@export var ZOOM_MARGIN: Vector2 = Vector2(200, 200)
@export_range(0.1, 10) var SMOOTHING: float = 5.0





@export var max_x: float = 10.0
@export var max_y: float = 10.0
@export var max_r: float = 25.0
@export var camera_move_speed: float = 200.0
@export var camera_rotation_speed: float = 100.0
@export_range(0, 1.0) var trauma_recovery: float = 1.0 

var trauma: float = 0.0 # range(0.0, 1.0)
var time: float = 0.0

@onready var camera: Camera2D = $Camera2D
@onready var init_camera_position: Vector2 = camera.position
const init_camera_rotation: float = 0.0

var targets: Dictionary

func _ready() -> void:
	GlobalSignals.signal_shake.connect(_shake)
	area_entered.connect(_detectTrauma)

func add_target(node2D: Node2D) -> void:
	targets[node2D.get_instance_id()] = node2D

func remove_target(node2D: Node2D) -> void:
	targets.erase(node2D.get_instance_id())

func clear_targets() -> void:
	targets.clear()

func set_target(node2D: Node2D) -> void:
	clear_targets()
	add_target(node2D)

func _process(delta: float) -> void:
	_handle_shake(delta)

func _handle_shake(delta: float) -> void:
	time += delta
	trauma = max(trauma - delta * trauma_recovery, 0.0) # TODO: comment out if want constant shake (like handheld camera)
	var shake_intensity: float = _calc_shake_intensity()
	camera.position.x = init_camera_position.x + max_x * shake_intensity * _get_noise_from_seed(0)
	camera.position.y = init_camera_position.y + max_y * shake_intensity * _get_noise_from_seed(1)
	camera.rotation_degrees = init_camera_rotation + max_r * shake_intensity * _get_noise_from_seed(2)

# Called in sync with frame rate (1/60th second), so delta should be constant
func _physics_process(delta: float) -> void:
	_handle_target_movement(delta)
	_handle_debug_movement(delta)

func _handle_target_movement(delta: float) -> void:
	if (targets.values().size() == 0):
		return
	 
	var min_pos: Vector2 = Vector2(999999999, 99999999)
	var max_pos: Vector2 = Vector2(-999999999, -99999999)
	for node2d: Node2D in targets.values():
		min_pos = Vector2(min(min_pos.x, node2d.global_position.x), min(min_pos.y, node2d.global_position.y))
		max_pos = Vector2(max(max_pos.x, node2d.global_position.x), max(max_pos.y, node2d.global_position.y))

	var center: Vector2 = (max_pos + min_pos) / 2.0
	global_position = lerp(global_position, center, delta * SMOOTHING)
	
	var screen_size: Vector2 = GlobalFunctions.get_viewport_size()
	var calc_zoom: Vector2 = (max_pos - min_pos + ZOOM_MARGIN) / screen_size
	var target_zoom: float = 1 / max(calc_zoom.x, calc_zoom.y, 1)
	camera.zoom = lerp(camera.zoom, Vector2(target_zoom, target_zoom), delta * SMOOTHING)


func _handle_debug_movement(delta: float)	-> void:
	var v = Input.get_axis("camera_up", "camera_down")
	var h = Input.get_axis("camera_left", "camera_right")
	var r = Input.get_axis("camera_rotate_ccw", "camera_rotate_cw")
	var z = Input.get_axis("camera_zoom_in", "camera_zoom_out")
	global_position += Vector2(h, v) * camera_move_speed * delta
	rotation_degrees += r * camera_rotation_speed * delta
	camera.zoom += Vector2(z, z) * 5 * delta


func _get_noise_from_seed(seed: int) -> float:
	noise.seed = seed
	return noise.get_noise_1d(time * noise_speed) # TODO: use Time.get_ticks_msec()?

func _add_trauma(amount: float) -> void:
	trauma = clamp(trauma + amount, 0.0, 1.0)

func _calc_shake_intensity() -> float:
	return trauma * trauma

func _shake(amount: float) -> void:
	print("Received signal_shake " + str(amount))
	_add_trauma(amount)

func _detectTrauma(area2D: Area2D) -> void:
	if (area2D is TraumaArea):
		var traumaArea: TraumaArea = area2D
		print("Detected TraumaArea " + str(traumaArea.amount) + " " + str(traumaArea.get_rid()))
		_add_trauma(traumaArea.amount)
