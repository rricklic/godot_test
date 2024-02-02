extends VBoxContainer

@onready var start_game_button: Button = $StartGame
@onready var quit_game_button: Button = $QuitGame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game_button.button_down.connect(_on_start_button_pressed)
	quit_game_button.button_down.connect(_on_quit_button_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed():
	var shader_outs: Array[ShaderTransition]
	var shader_ins: Array[ShaderTransition]
	SceneManager.instance.signal_transition.emit(self, "res://scenes/4_game_select/game_select.tscn", shader_outs, shader_ins)

func _on_quit_button_pressed():
	# TODO: add popup (are you sure?)
	get_tree().quit()
