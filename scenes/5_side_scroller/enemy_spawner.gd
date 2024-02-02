extends Node2D

var current_wave: int = 0

var enemy_1: PackedScene = preload("res://scenes/5_side_scroller/enemy1.tscn")

# TODO: add velocity x and y
# TODO: use pattern to adjust movement 

var waves_dict: Array = [
	{
		"enemy" : enemy_1,
		"num" : 5,
		"pattern" : "line",
		"start_pos" : Vector2(0, 0),
		"offset" : Vector2(25, 0),
		"delay_start" : 10
	},
	{
		"enemy" : enemy_1,
		"num" : 4,
		"pattern" : "line",
		"start_pos" : Vector2(0, 50),
		"offset" : Vector2(25, 0),
		"delay_start" : 5
	},
	{
		"enemy" : enemy_1,
		"num" : 20,
		"pattern" : "line",
		"start_pos" : Vector2(0, -50),
		"offset" : Vector2(25, 0),
		"delay_start" : 2
	}
]

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_start_wave)
	timer.wait_time = waves_dict[current_wave].delay_start
	timer.one_shot = true
	timer.start()

func _physical_process(delta: float) -> void:
	pass
	
func _start_wave() -> void:
	# Spawn wave
	var position: Vector2 = waves_dict[current_wave].start_pos
	for i in waves_dict[current_wave].num:
		var enemy: Node = waves_dict[current_wave].enemy.instantiate()
		enemy.global_position = position
		enemy.time = i * 0.1
		add_child(enemy)
		position += waves_dict[current_wave].offset
	
	# Queue up next wave
	current_wave += 1
	if current_wave < waves_dict.size():
		timer.wait_time = waves_dict[current_wave].delay_start
		timer.start()	
