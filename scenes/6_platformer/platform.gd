extends StaticBody2D

signal signal_move

@export var is_automove: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	signal_move.connect(_move)
	if (is_automove):
		_move

func _move() -> void:
	animation_player.play("move")
