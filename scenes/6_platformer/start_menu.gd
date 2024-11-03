extends MarginContainer

@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	start_button.grab_focus()
	start_button.pressed.connect(_start_game)
	quit_button.pressed.connect(_quit_game)

func _start_game() -> void:
	SceneMgr.signal_transition_file.emit("res://scenes/6_platformer/world_1.tscn")
	
func _quit_game() -> void:
	await LevelTransition.fade_to_black()
	get_tree().quit()
