extends Node2D

var ice_cream_scene: Resource = preload("res://test/mouse/ice_cream.tscn")
var ice_cream_count = 0

@onready var timer: Timer = $Timer
@onready var cone: Cone2 = $Cone
@onready var label: Label = $Label
@onready var audio_catch: AudioStreamPlayer = $AudioStreamPlayerCatch
@onready var audio_miss: AudioStreamPlayer = $AudioStreamPlayerMiss

func _ready() -> void:
	self.timer.start(randf_range(0, 3))
	self.timer.timeout.connect(_spawn_ice_cream)
	label.text = "Score " + str(ice_cream_count)

func _spawn_ice_cream() -> void:
	var ice_cream = ice_cream_scene.instantiate()
	ice_cream.signal_catch.connect(_on_ice_cream_catch)
	ice_cream.signal_miss.connect(_on_ice_cream_miss)
	self.add_child(ice_cream)
	self.timer.wait_time = randf_range(0, 3)

func _on_ice_cream_catch() -> void:
	cone.add_ice_cream()
	ice_cream_count += 1
	audio_catch.play()
	label.text = "Score " + str(ice_cream_count)

func _on_ice_cream_miss() -> void:
	audio_miss.play()

func _process(delta: float) -> void:
	pass
