extends Node2D

class_name EnemyManager

const enemyScene: PackedScene = preload("res://scenes/enemy.tscn")

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var timer: Timer = Timer.new()
var window_size: Vector2 = DisplayServer.window_get_size() # screen_get_size() - full screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	self.add_child(timer);
	timer.timeout.connect(_spawn_enemy)
	timer.start(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass

func _spawn_enemy() -> void:
	var spawn_side = rng.randi_range(0, 3); # 0 = top, 1 = bottom, 2 = left, 3 = right
	var enemy = enemyScene.instantiate()
	var x = rng.randf_range(0, window_size.x) if (spawn_side == 0 || spawn_side == 1) else (0.0 if spawn_side == 2 else window_size.x)
	var y = rng.randf_range(0, window_size.y) if (spawn_side == 2 || spawn_side == 3) else (0.0 if spawn_side == 0 else window_size.y)
	var position = Vector2(x, y)
	enemy.position = position
	self.add_child(enemy)
