extends Node2D

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var smile: Sprite2D = $Smile
@onready var skull: Sprite2D = $Skull

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_player.stream = load("res://audio/pickupCoin.wav")
	audio_player.play()
	
	var timer: SceneTreeTimer = get_tree().create_timer(4.0, true, false, false) 
	timer.timeout.connect(_fade_out)
	
	var timer2: SceneTreeTimer = get_tree().create_timer(2.0, true, false, false) 
	timer2.timeout.connect(_toggle_skull.bind(true))

func _toggle_skull(is_visible: bool) -> void:
	skull.visible = is_visible
	smile.visible = !is_visible
	var timer: SceneTreeTimer = get_tree().create_timer(0.05, true, false, false) 
	timer.timeout.connect(_toggle_skull.bind(false))	

func _fade_out() -> void:
	var shader_outs: Array[ShaderTransition]
	shader_outs.push_back(ShaderTransition.init("res://shaders/transition/color_fade.gdshader")
		.add_param("amount", 0.0, 1.0, 3.0, Tween.EASE_IN_OUT, Tween.TRANS_LINEAR)
		.add_param("target_color", [0.0, 0.0, 0.0, 1.0], [0.0, 0.0, 0.0, 1.0], 3.0, Tween.EASE_IN_OUT, Tween.TRANS_LINEAR))
	var shader_ins: Array[ShaderTransition]
	SceneManager.instance.signal_transition.emit(self, "res://scenes/3_title_screen/title_screen.tscn", shader_outs, shader_ins)
