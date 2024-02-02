extends Area2D

signal signal_catch
signal signal_miss

@onready var screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
func _ready() -> void:
	self.global_position.x = randi_range(0, 320)
	self.global_position.y = -20
	self.area_entered.connect(_on_collision)
	self.screen_notifier.screen_exited.connect(_on_offscreen)

func _process(delta: float) -> void:
	self.global_position.y += 2

func _on_collision(area: Area2D) -> void:
	signal_catch.emit()
	queue_free()
	
func _on_offscreen() -> void:
	signal_miss.emit()
	queue_free()
