class_name World1 extends Node2D

var next_level: PackedScene = load("res://scenes/6_platformer/world_2.tscn")
var start_time: float = 0.0

@onready var player: Player = $Player
@onready var camera: CameraEx2D = $CameraEx2D
@onready var level_completed: ColorRect = $UILayer/LevelComplete

@onready var start_in_color_rect: ColorRect = %StartInColorRect
@onready var start_in_label: Label = %StartInLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var level_time_label: Label = %LevelTimeLabel

func _ready() -> void:
	GlobalSignals.signal_level_completed.connect(_show_completed)
	level_completed.signal_retry.connect(_retry_level)
	level_completed.signal_next.connect(_goto_next_level)

	camera.set_target(player)
	camera.global_position = player.global_position
	
	start_in_color_rect.visible = true
	get_tree().paused = true
	await animation_player.animation_finished
	start_in_color_rect.visible = false
	get_tree().paused = false
	
	start_time = Time.get_ticks_msec()

func _process(_delta: float) -> void:
	level_time_label.text = str((Time.get_ticks_msec() - start_time) / 1000)

func  _retry_level() -> void:
	SceneMgr.signal_transition_packed_scene.emit(load(scene_file_path))

func _goto_next_level() -> void:
	SceneMgr.signal_transition_packed_scene.emit(next_level)
	
func _show_completed() -> void:
	if !(next_level is PackedScene):
		next_level = load("res://scenes/6_platformer/victory_screen.tscn")

	get_tree().paused = true
	var timer: SceneTreeTimer = get_tree().create_timer(1.0)
	await timer.timeout
	level_completed.show()
