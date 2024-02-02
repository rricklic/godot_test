extends Node2D

@onready var timer: Timer = $Timer
var dropping_item_scene: Resource = preload("res://test/nodes/dropping_item.tscn")

func _ready() -> void:
	timer.start(randf_range(1, 5))
	timer.timeout.connect(_drop_object)

func _process(delta: float) -> void:
	pass
	
func _drop_object() -> void:
	var object = dropping_item_scene.instantiate()
	object.global_position = Vector2(randf_range(50, 150), - 50)
	self.add_child(object)
	self.timer.wait_time = randf_range(1, 5)
