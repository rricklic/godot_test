extends CenterContainer

@onready var main_menu_button: Button = %MainMenuButton

func _ready() -> void:
	get_tree().paused = false
	main_menu_button.grab_focus()
	main_menu_button.pressed.connect(_goto_main_menu)
	
func _goto_main_menu() -> void:
	SceneMgr.signal_transition_file.emit("res://scenes/6_platformer/start_menu.tscn")
