class_name Score extends Node2D

var score: int = 0

@onready var label: Label = $Label

func set_signal(sig_update_score: Signal) -> void:
	if (sig_update_score):
		sig_update_score.connect(update_score)

func _ready() -> void:
	label.text = str(score)

func update_score(value: int) -> void:
	score += value
	label.text = str(score)
	
func reset_score() -> void:
	score = 0
	label.text = str(score)
