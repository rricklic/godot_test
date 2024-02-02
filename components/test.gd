extends Node2D

signal sig_foo(value: int)
signal sig_bar(value: int)

var cooloff_keyboard: CoolOff = CoolOff.new(0.1)
var scene_score: PackedScene = preload("res://components/scenes/score.tscn")

@onready var camera: CameraEx2D = $CameraEx2D
@onready var player1: Node2D = $Player1
@onready var hurtbox2: Hurtbox = $Hurtbox2
@onready var enemy1: Node2D = $Enemy1
@onready var enemy2: Node2D = $Enemy2

func _ready() -> void:
	var score = scene_score.instantiate()
	score.global_position = Vector2(10, 10)
	score.set_signal(sig_foo)
	add_child(score)

	score = scene_score.instantiate()
	score.global_position = Vector2(100, 10)
	score.set_signal(sig_bar)
	add_child(score)
	remove_child(score)
	
	camera.add_target(player1)
	
	player1.hurtbox.signal_hurt.connect(_player1_hurt)
	hurtbox2.signal_hurt.connect(_player2_hurt)
	
func _enter_tree() -> void:
	get_tree().create_timer(30.0).timeout.connect(_transition)
	
func _transition() -> void:
	var transition_outs: Array[SceneTransitionShader]
	transition_outs.push_back(SceneTransitionShader.new(SceneTransitionShader.Transition.PIXELATE))
	transition_outs.push_back(SceneTransitionShader.new(SceneTransitionShader.Transition.COLOR_FADE))
	
	var transition_ins: Array[SceneTransitionShader]
	transition_ins.push_back(SceneTransitionShader.new(SceneTransitionShader.Transition.PIXELATE_2))
	transition_ins.push_back(SceneTransitionShader.new(SceneTransitionShader.Transition.COLOR_FADE_2))
	
	SceneMgr.signal_transition.emit("res://components/test2.tscn", transition_outs, transition_ins, false)

func _process(delta: float) -> void:
	cooloff_keyboard.decrement(delta)
	
func _physics_process(delta: float) -> void:
	if cooloff_keyboard.is_ready() && Input.is_key_pressed(KEY_A):
		cooloff_keyboard.reset()
		sig_foo.emit(1)
		GlobalSignals.signal_shake.emit(1.00)

	elif cooloff_keyboard.is_ready() && Input.is_key_pressed(KEY_Z):
		cooloff_keyboard.reset()
		sig_bar.emit(1)

	
	if (Input.is_key_pressed(KEY_1)):
		camera.set_target(player1)
	if (Input.is_key_pressed(KEY_2)):
		camera.set_target(hurtbox2)
	if (Input.is_key_pressed(KEY_3)):
		camera.set_target(enemy1)
	if (Input.is_key_pressed(KEY_4)):
		camera.set_target(enemy2)


		
	
	var direction = Input.get_axis("player2_left", "player2_right")
	enemy2.global_position.x += direction * 100 * delta
	direction = Input.get_axis("player2_up", "player2_down")
	enemy2.global_position.y += direction * 100 * delta

func _player1_hurt(hitbox: Hitbox) -> void:
	print("player 1 hit by " + str(hitbox.get_rid()))
	sig_foo.emit(hitbox.damage)

func _player2_hurt(hitbox: Hitbox) -> void:
	print("player 2 hit by " + str(hitbox.get_rid()))
	sig_bar.emit(hitbox.damage)
